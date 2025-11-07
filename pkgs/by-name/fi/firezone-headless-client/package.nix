{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-headless-client";
  version = "1.5.4";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "headless-client-${version}";
    hash = "sha256-dVqZs5Xie9lc3F6wVMdxRHeoM7y/e9TvwjzfikenQ6w=";
  };

  cargoHash = "sha256-J2IqqFBuoTkbO0nMJbY680G2HTAtC1To/nMra2PCopY=";
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
