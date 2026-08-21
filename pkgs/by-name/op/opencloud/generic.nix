{
  version,
  production ? false,
  hash,
  webVersion,
  webHash,
  webPnpmDepsHash,
  idpWebPnpmDepsHash,
  nixUpdateExtraArgs ? [ ],
}:

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ncurses,
  gettext,
  pigeon,
  protoc-go-inject-tag,
  libxcrypt,
  vips,
  pkg-config,
  nixosTests,
  nix-update-script,
  versionCheckHook,
  stdenvNoCC,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmBuildHook,
  pnpmConfigHook,
}:

let
  maintainers = with lib.maintainers; [
    christoph-heiss
    k900
    deadbaed
  ];
  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "opencloud";
    tag = "v${version}";
    inherit hash;
  };
  bingoBinsMakefile = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (n: v: "${n} := ${v}\n\\$(${n}):") {
      GO_XGETTEXT = "xgettext";
      # no need to generate mocks, as they are in-repo already
      MOCKERY = "true";
      PIGEON = "pigeon";
      PROTOC_GO_INJECT_TAG = "protoc-go-inject-tag";
    }
  );
  web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "opencloud-web";
    version = webVersion;

    src = fetchFromGitHub {
      owner = "opencloud-eu";
      repo = "web";
      tag = "v${finalAttrs.version}";
      hash = webHash;
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = webPnpmDepsHash;
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
    ];

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist/* $out
      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Web UI for OpenCloud built with Vue.js and TypeScript";
      homepage = "https://github.com/opencloud-eu/web";
      changelog = "https://github.com/opencloud-eu/web/blob/${finalAttrs.src.tag}/CHANGELOG.md";
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.all;
      inherit maintainers;
    };
  });

  idp-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "opencloud-idp-web";

    inherit src version;

    pnpmRoot = "services/idp";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_11;
      sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
      fetcherVersion = 4;
      hash = idpWebPnpmDepsHash;
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpmBuildHook
      pnpm_11
    ];

    postBuild = ''
      mkdir -p services/idp/assets/identifier/static
      cp -v services/idp/src/images/favicon.svg services/idp/assets/identifier/static/favicon.svg
      cp -v services/idp/src/images/icon-lilac.svg services/idp/assets/identifier/static/icon-lilac.svg
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r services/idp/assets $out

      runHook postInstall
    '';

    meta = {
      description = "OpenCloud - IDP Web UI";
      homepage = "https://github.com/opencloud-eu/opencloud";
      changelog = "https://github.com/opencloud-eu/opencloud/blob/${finalAttrs.src.tag}/CHANGELOG.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
      inherit maintainers;
    };
  });
in
buildGoModule (finalAttrs: {
  inherit version src;
  pname = "opencloud" + lib.optionalString production "-production";

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    echo "${bingoBinsMakefile}" >.bingo/Variables.mk

    # tries to build web assets, done separately
    substituteInPlace services/idp/Makefile \
      --replace-fail 'node-generate-prod: assets' 'node-generate-prod:'
    # tries to download something web assets ..
    substituteInPlace services/web/Makefile \
      --replace-fail 'node-generate-prod: download-assets' 'node-generate-prod:'

    # tries to build some random binaries off the internet and
    # no need to build protobuf bindings anyway, as they are in-repo already
    sed -i -e '/\$(BINGO) get/d' -e '/\$(BUF) generate/d' .make/protobuf.mk
  '';

  vendorHash = null;

  preConfigure = ''
    export HOME=$(mktemp -d)
    make generate
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/opencloud-eu/opencloud/pkg/version.String=nixos"
    "-X"
    "github.com/opencloud-eu/opencloud/pkg/version.Tag=${finalAttrs.version}"
    "-X"
    "github.com/opencloud-eu/opencloud/pkg/version.Date=19700101"
  ];

  tags = [ "enable_vips" ];

  nativeBuildInputs = [
    ncurses
    gettext
    pigeon
    protoc-go-inject-tag
    pkg-config
  ];

  buildInputs = [
    libxcrypt
    vips
  ];

  # wants testcontainers and docker, and we don't have a good way to skip tests
  # based on package name and not test name
  preCheck = ''
    rm services/search/pkg/opensearch/*_test.go
  '';

  # The activitylog tests start a local NATS server.
  __darwinAllowLocalNetworking = true;

  env = {
    # avoids 'make generate' calling `git`, otherwise no-op
    STRING = finalAttrs.version;
    VERSION = finalAttrs.version;
    # avoids weird test failure
    AUTOMEMLIMIT = "off";
  };

  excludedPackages = [ "tests/*" ];

  passthru = {
    inherit web idp-web;
    tests = if production then nixosTests.opencloud-production else nixosTests.opencloud;
    updateScript = nix-update-script {
      extraArgs = nixUpdateExtraArgs ++ [
        "--version-regex"
        "v(${if production then lib.versions.majorMinor else lib.versions.major version}\\.[0-9.]+)"
      ];
    };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "OpenCloud gives you a secure and private way to store, access, and share your files";
    homepage = "https://github.com/opencloud-eu/opencloud";
    changelog = "https://github.com/opencloud-eu/opencloud/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "opencloud";
    inherit maintainers;
  };
})
