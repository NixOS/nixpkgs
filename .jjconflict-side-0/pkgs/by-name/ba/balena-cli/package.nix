{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  versionCheckHook,
  node-gyp,
  python3,
  udev,
  cctools,
  apple-sdk_12,
}:

let
  buildNpmPackage' = buildNpmPackage.override {
    nodejs = nodejs_20;
  };
  node-gyp' = node-gyp.override {
    nodejs = nodejs_20;
  };
in
buildNpmPackage' rec {
  pname = "balena-cli";
  version = "21.1.9";

  src = fetchFromGitHub {
    owner = "balena-io";
    repo = "balena-cli";
    rev = "v${version}";
    hash = "sha256-oeOhE4cgN/u9zLEXoiMbbE+onNJvrX8wNjoydh20Wdk=";
  };

  npmDepsHash = "sha256-ggdCry0MtA/UZIlm8mrC7TdcAoj2pTgq7kWSqMN5siM=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';
  makeCacheWritable = true;

  nativeBuildInputs =
    [
      node-gyp'
      python3
      versionCheckHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      udev
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_12
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
