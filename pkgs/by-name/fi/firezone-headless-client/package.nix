{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-headless-client";
  version = "1.4.6";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "headless-client-${version}";
    hash = "sha256-ra5ZWPwNhyZEc9pBkcITvQyomgQ22yiWI16dnv1Fm3E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5B9nvFanHXZV8p8m2vsRLC5pSzwL2lX+V651oV8joJs=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "headless-client";
  RUSTFLAGS = "--cfg system_certs";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  # Required to run tests
  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "headless-client-(.*)"
    ];
  };

  meta = {
    description = "CLI client for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-headless-client";
    platforms = lib.platforms.linux;
  };
}
