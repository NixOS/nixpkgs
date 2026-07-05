{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firezone-headless-client";
  version = "1.5.10";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "headless-client-${finalAttrs.version}";
    hash = "sha256-Q2fV0+r/kntsby4cscEkJfBiOTfFS+nyqK5+7LyN76s=";
  };

  cargoHash = "sha256-IUELCciBLAygMW/5rhNwMFkYqwDompKgHwHIAy03254=";
  sourceRoot = "${finalAttrs.src.name}/rust";
  buildAndTestSubdir = "headless-client";
  env.RUSTFLAGS = "--cfg system_certs";

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
})
