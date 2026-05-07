{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  versionCheckHook,
  node-gyp,
  python3,
  udev,
  xcbuild,
}:

let
  buildNpmPackage' = buildNpmPackage.override {
    nodejs = nodejs_24;
  };
  node-gyp' = node-gyp.override {
    nodejs = nodejs_24;
  };
in
buildNpmPackage' rec {
  pname = "balena-cli";
  version = "25.1.3";

  src = fetchFromGitHub {
    owner = "balena-io";
    repo = "balena-cli";
    rev = "v${version}";
    hash = "sha256-zDjSzjR5y4fQPMRVuddf3zTddFoaR4p1D6v/+BHQzZo=";
  };

  npmDepsHash = "sha256-VE4HY8gRlB6r+qS/56Tj0UackFxO35/MFSY2l4EH0kY=";

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
