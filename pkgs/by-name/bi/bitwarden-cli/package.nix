{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  perl,
  xcbuild,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "bitwarden-cli";
<<<<<<< HEAD
  version = "2025.12.0";
=======
  version = "2025.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    tag = "cli-v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Pas9NQKLblVuB0Gx4j6Y64Mb2+RaCg7iquSWtN4K7kU=";
=======
    hash = "sha256-wG0JKQKjNAEoQt/8BFIzISNNUrBqKQHPZ8DRJ69eA5s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    ./fix-lockfile.patch
  ];

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_22;

<<<<<<< HEAD
  npmDepsHash = "sha256-N7e8WKk2REEH4gP5c7k5zsu3n44hFFLxQ2X35viMuwM=";
=======
  npmDepsHash = "sha256-/57+ch1d1VMGIMO0Kzu6o3tUX/3adgLkONNRgtyARtQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    perl
    xcbuild.xcrun
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [ "--legacy-peer-deps" ];

  npmRebuildFlags = [
    # we'll run npm rebuild manually later
    "--ignore-scripts"
  ];

  postConfigure = ''
    # we want to build everything from source
    shopt -s globstar
    rm -r node_modules/**/prebuilds
    shopt -u globstar

    npm rebuild --verbose
  '';

  postBuild = ''
    # remove build artifacts that bloat the closure
    shopt -s globstar
    rm -r node_modules/**/{*.target.mk,binding.Makefile,config.gypi,Makefile,Release/.deps}
    shopt -u globstar
  '';

  postInstall = ''
    # The @bitwarden modules are actually npm workspaces inside the source tree, which
    # leave dangling symlinks behind. They can be safely removed, because their source is
    # bundled via webpack and thus not needed at run-time.
    rm -rf $out/lib/node_modules/@bitwarden/clients/node_modules/{@bitwarden,.bin}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bw --zsh <($out/bin/bw completion --shell zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    tests = {
      vaultwarden = nixosTests.vaultwarden.sqlite;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=stable"
        "--version-regex=^cli-v(.*)$"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${finalAttrs.src.tag}";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      dotlambda
    ];
  };
})
