{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-gateway";
  version = "1.4.18";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gateway-${version}";
    hash = "sha256-vxOFca6yO9AvgIJwizhaNlOjOvV00+ckQfXIJ17ASq4=";
  };

  cargoHash = "sha256-8YftVt72JpmxWB/WvOPpduE0/QgYvQhSuFRmsFth2iU=";
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
