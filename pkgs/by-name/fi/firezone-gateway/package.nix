{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-gateway";
  version = "1.4.17";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gateway-${version}";
    hash = "sha256-dVqZs5Xie9lc3F6wVMdxRHeoM7y/e9TvwjzfikenQ6w=";
  };

  cargoHash = "sha256-J2IqqFBuoTkbO0nMJbY680G2HTAtC1To/nMra2PCopY=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "gateway";
  RUSTFLAGS = "--cfg system_certs";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "gateway-(.*)"
    ];
  };

  meta = {
    description = "WireGuard tunnel server for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-gateway";
    platforms = lib.platforms.linux;
  };
}
