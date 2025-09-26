{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-flatland";
  version = "0-unstable-2024-04-13";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "b3b0f29c4ea1b82c96cf9de507837bf15a5e4c0e";
    hash = "sha256-m7c6XpmpTM1URuqMG2KqtaWbL2Vt8vJFJtmvq123BmY=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoHash = "sha256-oM4nQUEc3iq1x4uRp8Kw5WtE/L5b6VlLOfElMT9Tk98=";

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
