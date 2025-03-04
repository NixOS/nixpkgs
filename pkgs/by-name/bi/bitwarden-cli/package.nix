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
  version = "2025.1.3";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-a8OQ/vQCJSjipLnuNWaWqnAJK+Str6FdHPBTbC04VxA=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_20;

  npmDepsHash = "sha256-BoHwgv/1QiIfUPCJ3+ZHvbMelngRSEKlbkpBHRtnoP8=";

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

  postInstall = ''
    # The @bitwarden modules are actually npm workspaces inside the source tree, which
    # leave dangling symlinks behind. They can be safely removed, because their source is
    # bundled via webpack and thus not needed at run-time.
    rm -rf $out/lib/node_modules/@bitwarden/clients/node_modules/{@bitwarden,.bin}
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
