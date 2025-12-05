{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_latest,
  versionCheckHook,
  node-gyp,
  python3,
  udev,
  xcbuild,
}:

let
  buildNpmPackage' = buildNpmPackage.override {
    nodejs = nodejs_latest;
  };
  node-gyp' = node-gyp.override {
    nodejs = nodejs_latest;
  };
in
buildNpmPackage' rec {
  pname = "balena-cli";
  version = "23.2.2";

  src = fetchFromGitHub {
    owner = "balena-io";
    repo = "balena-cli";
    rev = "v${version}";
    hash = "sha256-HAcsFGLUUaeNxEBAFgYjDipu8QTsd+8yptC6kAX0C4g=";
  };

  npmDepsHash = "sha256-dT5WrrzrO5tcP4/NFe5WTG7boYTOlFRNut52X2AWaao=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    node-gyp'
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  # Disabled on Darwin due to:
  #
  # https://github.com/NixOS/nix/issues/5748
  #
  # No matter whether $TMP and $HOME point to real writable directories, the
  # Darwin sandbox tries to use /var/empty and fails.
  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  versionCheckProgram = "${placeholder "out"}/bin/balena";

  meta = {
    description = "Command line interface for balenaCloud or openBalena";
    longDescription = ''
      The balena CLI is a Command Line Interface for balenaCloud or openBalena. It is a software
      tool available for Windows, macOS and Linux, used through a command prompt / terminal window.
      It can be used interactively or invoked in scripts. The balena CLI builds on the balena API
      and the balena SDK, and can also be directly imported in Node.js applications.
    '';
    homepage = "https://github.com/balena-io/balena-cli";
    changelog = "https://github.com/balena-io/balena-cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalebpace
      doronbehar
    ];
    mainProgram = "balena";
  };
}
