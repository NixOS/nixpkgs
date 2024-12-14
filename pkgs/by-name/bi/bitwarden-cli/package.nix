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
  version = "2024.11.1";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-J7gmrSAiu59LLP9pKfbv9+H00vXGQCrjkd4GBhkcyTY=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_20;

  npmDepsHash = "sha256-MZoreHKmiUUxhq3tmL4lPp6vPmoQIqG3IPpZE56Z1Kc=";

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
