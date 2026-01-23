{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-phobetor";
  version = "0-unstable-2024-02-10";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "phobetor";
    rev = "f47d10c9ab8b37941bc9ca94677d6c80332376f3";
    hash = "sha256-7CWOoirQ/8zKCO7lBA9snyShlwsKYONiYkl39lQrpTY=";
  };

  env.STARDUST_RES_PREFIXES = "${src}/res";

  cargoHash = "sha256-H65uAHMAIkJ9D5q/5HxMEbvcfoRhYdFgTQejp6bvu5w=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Handheld panel shell for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "phobetor";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
