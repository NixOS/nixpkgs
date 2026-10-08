{
  withLocales ? true,

  buildGoModule,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  applyPatches,
  lib,
  nixosTests,
  stdenvNoCC,
}:

let
  version = "2024.9.9";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "cortezaproject";
      repo = "corteza";
      tag = version;
      hash = "sha256-r6/z5yplkT2d1iEhA4S29C1LcbdEJQiOWr0JRP5Pvb0=";
    };
    patches = [
      # CVE-2026-6093
      (fetchpatch {
        url = "https://github.com/cortezaproject/corteza/commit/64b58b9d7324e77248bacd183fb994ff338091ec.patch";
        hash = "sha256-0Ume1zkksS3kwf6QS6T5lDXklAboZVlTt5ZJReqwu3w=";
      })
    ];
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
    admin = "sha256-fen4KxPbYpH0ikWco1w3Zr+4WeghFITdmsOqHMGa3gA=";
    compose = "sha256-UHhyzCeSWTROgzULYkDKN/2hgZ25aDZ7roHTLkt466o=";
    discovery = "sha256-GHmALrqLTBie0VTDmZz4zJ9Ls2JYsfV0A3VkRwCKSuQ=";
    one = "sha256-GHCtouGYrFgghWlBVbF5rD9cXrAfleVVxVqZtuLOSr0=";
    privacy = "sha256-PlmeAJZY/S+osdM650tpJI3XSOanc80WYuMQ6jsiJwQ=";
    reporter = "sha256-4O6FEF7Ol4V0FxznKGISaIA0w68XL0E3HvQ8bbt2klE=";
    workflow = "sha256-2vyx3lCxICtVlRFLPkpy0fzXZ9W4li9ESm9sJzInc8g=";
  };

  server-webconsole = callPackage ./buildYarnDistOnly.nix {
    inherit version src meta;
    pname = "corteza-server-webconsole";
    sourceDir = "server/webconsole";
    yarnLock = ./server-webconsole-yarn.lock;
    hash = "sha256-GMXrQtplreg/3bWfRwQQwDNiHQNl6YHF5nhmFNCYsiM=";
  };

  corteza-locale = fetchFromGitHub {
    owner = "cortezaproject";
    repo = "corteza-locale";
    rev = "57b1f2403207c44055ebce19d95cedd5573f39df";
    sha256 = "sha256-j+mfWG6tED8AACkUcRWpol2G05qknTxp8b+kwu7c2NA=";
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
