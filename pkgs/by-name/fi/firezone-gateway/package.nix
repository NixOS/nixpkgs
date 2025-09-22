{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-gateway";
  version = "1.4.16";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gateway-${version}";
    hash = "sha256-Tu0Bq/Axj05dCRCd1eB7CiOXQ5n4i8hnE3ZiGCQ5ZdY=";
  };

  cargoHash = "sha256-wlf+TtrRG7hHNav7WqLn2DSX9QkKFVzyiKP5CRdXlNY=";
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
