{
  lib,
  stdenv,
  buildNpmPackage,
  nodejs_20,
  fetchFromGitHub,
  cctools,
  nix-update-script,
  nixosTests,
  perl,
  xcbuild,
}:

buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2025.5.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    tag = "cli-v${version}";
    hash = "sha256-8jVKwqKhTfhur226SER4sb1i4dY+TjJRYmOY8YtO6CY=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_20;

  npmDepsHash = "sha256-0IoBPRGdtkMeTrT5cqZLHB/WrUCONtsJ6YHh0y4K5Ls=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
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

    # FIXME one of the esbuild versions fails to download @esbuild/linux-x64
    rm -r node_modules/esbuild node_modules/vite/node_modules/esbuild

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
    # https://github.com/NixOS/nixpkgs/issues/339576
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.tag}";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
