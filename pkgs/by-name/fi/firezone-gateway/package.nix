{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firezone-gateway";
  version = "1.6.5";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gateway-${finalAttrs.version}";
    hash = "sha256-J63L+Rj9w6ao8ilhcU/5kYHmpILQFcVdNknZrBstepM=";
  };

  cargoHash = "sha256-b7zHI9dMvg+ZcVeGRuV3aVXUb+bhQhZmdg96ggQUwV4=";
  sourceRoot = "${finalAttrs.src.name}/rust";
  buildAndTestSubdir = "gateway";
  env.RUSTFLAGS = "--cfg system_certs";

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
})
