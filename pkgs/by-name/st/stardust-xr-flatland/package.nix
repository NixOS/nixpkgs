{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-flatland";
  version = "0.50.1-unstable-2025-12-24";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "add9b3420940a5608116d02d3dbf53fbd3eb7c40";
    hash = "sha256-yjJ1sSztpIDYPD9ukPfe/4sdkm303XJE1qDd8J79xhQ=";
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
