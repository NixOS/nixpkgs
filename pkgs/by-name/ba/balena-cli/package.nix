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
  cctools,
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
  version = "23.2.0";

  src = fetchFromGitHub {
    owner = "balena-io";
    repo = "balena-cli";
    rev = "v${version}";
    hash = "sha256-T4eOiFpU17vAwAM02gwJq93ZtJQUC7bv0CCFpj4NKEA=";
  };

  npmDepsHash = "sha256-kRkc3o8xmROlH17GI3yoGvMwEweHrLeGpvW3rH0wOSU=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    node-gyp'
    python3
    versionCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  doInstallCheck = true;
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
