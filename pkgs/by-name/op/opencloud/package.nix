{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  ncurses,
  gettext,
  pigeon,
  go-mockery,
  protoc-go-inject-tag,
  libxcrypt,
  vips,
  pkg-config,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

let
  bingoBinsMakefile = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (n: v: "${n} := ${v}\n\\$(${n}):") {
      GO_XGETTEXT = "xgettext";
      MOCKERY = "mockery";
      PIGEON = "pigeon";
      PROTOC_GO_INJECT_TAG = "protoc-go-inject-tag";
    }
  );
in
buildGoModule rec {
  pname = "opencloud";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "opencloud";
    tag = "v${version}";
    hash = "sha256-NPBz9pevjDUqDrEg/S6Vtk+jAA9f2H95ehO8EgcB1eY=";
  };

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
    "github.com/opencloud-eu/opencloud/pkg/version.Tag=${version}"
    "-X"
    "github.com/opencloud-eu/opencloud/pkg/version.Date=19700101"
  ];

  tags = [ "enable_vips" ];

  nativeBuildInputs = [
    ncurses
    gettext
    pigeon
    go-mockery
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

  env = {
    # avoids 'make generate' calling `git`, otherwise no-op
    STRING = version;
    VERSION = version;
  };

  excludedPackages = [ "tests/*" ];

  passthru = {
    web = callPackage ./web.nix { };
    idp-web = callPackage ./idp-web.nix { };
    tests = { inherit (nixosTests) opencloud; };
    updateScript = nix-update-script { };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "OpenCloud gives you a secure and private way to store, access, and share your files";
    homepage = "https://github.com/opencloud-eu/opencloud";
    changelog = "https://github.com/opencloud-eu/opencloud/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      christoph-heiss
      k900
    ];
    mainProgram = "opencloud";
  };
}
