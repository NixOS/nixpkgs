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
  version = "2025.1.2";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-Ibf25+aaEKFUCp5uiqmHySfdZq2JPAu2nBzfiS4Sc/k=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_20;

  npmDepsHash = "sha256-+LpF5zxC4TG5tF+RNgimLyEmGYyUfFDXHqs2RH9oQLY=";

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

  # FIXME temporarily disable the symlink check as there are symlink after the build in the `node_modules/@bitwarden` directory linking to `../../`.
  dontCheckForBrokenSymlinks = true;

  npmRebuildFlags = [
    # FIXME one of the esbuild versions fails to download @esbuild/linux-x64
    "--ignore-scripts"
  ];

  postConfigure = ''
    # we want to build everything from source
    shopt -s globstar
    rm -r node_modules/**/prebuilds
    shopt -u globstar
  '';

  postBuild = ''
    # remove build artifacts that bloat the closure
    shopt -s globstar
    rm -r node_modules/**/{*.target.mk,binding.Makefile,config.gypi,Makefile,Release/.deps}
    shopt -u globstar
  '';

  passthru = {
    tests = {
      vaultwarden = nixosTests.vaultwarden.sqlite;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--commit"
        "--version=stable"
        "--version-regex=^cli-v(.*)$"
      ];
    };
  };

  meta = with lib; {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with maintainers; [ dotlambda ];
  };
}
