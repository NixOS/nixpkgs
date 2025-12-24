{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-flatland";
  version = "0.50.0-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "e1e5ae83a71891660037d399184264e411c1100a";
    hash = "sha256-RB1bMPZganJbhgcKchN4fkQqgKYJ8XDjdA/vA3TJ/u4=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoHash = "sha256-ia36KNvk2D9zGh3IBXS1s0yXZw6DGdPkp+0cAq2c3Fc=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Flat window for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "flatland";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
