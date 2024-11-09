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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.14.1" = "sha256-HEv1KzemGHEEcfFrzgKJmHUhGsW95J+6bcK7Bb8T9KE=";
      "stardust-xr-molecules-0.29.0" = "sha256-yAdoJiTEulZiwRzhgoQ2cDUBxCe6NcTm88TfvDJ9Co4=";
    };
  };

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
