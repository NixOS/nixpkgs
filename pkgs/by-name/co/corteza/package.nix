{
  withLocales ? true,

  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,
  nixosTests,
  stdenvNoCC,
}:

let
  version = "2026.9.0";
  src = fetchFromGitHub {
    owner = "cortezaproject";
    repo = "corteza";
    tag = version;
    hash = "sha256-v5OZ2gW8Yqq317AdTPgh3vcpLxMB8U+NQ6OYv1CPdVI=";
  };
  meta = {
    description = "Low-code platform";
    longDescription = ''
      The Corteza low-code platform lets you build and iterate CRM, business
      process and other structured data apps fast, create intelligent business
      process workflows and connect with almost any data source.
    '';
    homepage = "https://cortezaproject.org/";
    downloadPage = "https://github.com/cortezaproject/corteza/releases";
    changelog = "https://docs.cortezaproject.org/corteza-docs/${lib.versions.majorMinor version}/changelog/index.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
    teams = with lib.teams; [ ngi ];
  };

  mkWebApp =
    name: hash:
    callPackage ./buildYarnDistOnly.nix {
      inherit
        version
        src
        hash
        meta
        ;
      pname = "corteza-webapp-${name}";
      sourceDir = "client/web/${name}";
      extraFiles = "../../../{README.md,LICENSE,CONTRIBUTING.md,DCO}";
    };

  webApps = lib.mapAttrs mkWebApp {
    admin = "sha256-8ZVTNwpAAFaAZcreTdGJE94fP6ZLfsbMhUjKeOBGhrI=";
    compose = "sha256-ETIE5REdE32HQ8MVey4HSbAuswb0dkX0iw3LM5EJb6Y=";
    discovery = "sha256-lZBoTC0d9zj/Kcy4gNdDZQHGIqN0PmaAwj2Z0OXrVUI=";
    one = "sha256-URbxBXQelvXwuZV1Nj9r3fPgH9+I6kbmpVPLvyC3DVQ=";
    privacy = "sha256-wtr+yEGQ8MEuD5fDHT3sefKCVX5fS/KZpTnGaV4w0nA=";
    reporter = "sha256-OZgbTYMbe+H5Y6IT/wjpSqlNmBYggGkoYd9kCEre9pA=";
    workflow = "sha256-VHjAuZlpHOcttW1MgrcWYnfPR8V43jbMKfRFip7IjME=";
  };

  server-webconsole = callPackage ./buildYarnDistOnly.nix {
    inherit version src meta;
    pname = "corteza-server-webconsole";
    sourceDir = "server/webconsole";
    hash = "sha256-WhhPMsQmsUpNIbFPkM2wU7pIYNTfwzrSuZDQYFVZArQ=";
  };

  corteza-locale = fetchFromGitHub {
    owner = "cortezaproject";
    repo = "corteza-locale";
    rev = "1e859351bbf78c9052de64bccd06f6c8c237aac5";
    hash = "sha256-BUH+R686plBkhR7VVb/oWXNHKaVwwUDq+a7FaHYoKWE=";
  };

  corteza-webapp = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "corteza-webapp";
    inherit version meta;

    srcs = lib.attrValues webApps;
    sourceRoot = ".";

    buildPhase = ''
      runHook preBuild

      cp --no-preserve=mode -r ${webApps.one.name} dist
      ${lib.concatStringsSep "\n" (
        lib.attrValues (
          lib.mapAttrs (name: src: ''
            cp -r ${src.name} dist/${name}
          '') (lib.removeAttrs webApps [ "one" ])
        )
      )}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';
  });

  corteza-server = buildGoModule (finalAttrs: {
    pname = "corteza-server";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/server";
    # already vendored
    vendorHash = null;

    preBuild = ''
      cp -r ../locale/en pkg/locale/src/
      cp -r ${server-webconsole}/* webconsole/dist/
    ''
    + lib.optionalString withLocales ''
      chmod -R u+w pkg/locale/src
      cp -r ${corteza-locale}/src/* pkg/locale/src/
    '';

    subPackages = [ "cmd/corteza" ];

    postInstall = ''
      mv $out/bin/corteza{,-server}
      cp -r provision .env.example ../{README.md,LICENSE,CONTRIBUTING.md,DCO} $out
      rm -f $out/provision/README.adoc $out/provision/update.sh
    '';

    meta = meta // {
      mainProgram = "corteza-server";
      platforms = lib.platforms.unix;
    };
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "corteza";
  inherit version;

  srcs = lib.attrValues finalAttrs.passthru.srcs;
  sourceRoot = ".";

  buildPhase = ''
    runHook preBuild

    cp --no-preserve=mode -r ${finalAttrs.passthru.srcs.corteza-server.name} dist
    chmod a+x dist/bin/corteza-server
    mkdir dist/webapp
    cp -r ${finalAttrs.passthru.srcs.corteza-webapp.name}/* dist/webapp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru = {
    srcs = { inherit corteza-server corteza-webapp; };
    tests = { inherit (nixosTests) corteza; };
  };

  inherit (corteza-server) meta;
})
