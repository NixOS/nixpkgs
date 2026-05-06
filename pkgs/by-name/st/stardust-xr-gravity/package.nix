{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-gravity";
  version = "0.51.0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    rev = "adca3464f3dc95b773c6c7b36b4c87d71b65f741";
    hash = "sha256-dkrpW1AOdf1zllvoyjsYOchJOUfPE/dlaGVAXPvXCCg=";
  };

  cargoHash = "sha256-vV8/WtAGWDIiUOGNZcK91SJ5M6aFBEPi6/k0I1MO/bI=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Utility to launch apps and stardust clients at an offet";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "gravity";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
