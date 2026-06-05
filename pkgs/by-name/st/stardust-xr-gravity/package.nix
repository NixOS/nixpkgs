{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-gravity";
  version = "0-unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    rev = "eca5e835cd3abee69984ce6312610644801457a9";
    hash = "sha256-upw0MjGccSI1B10wabKPMGrEo7ATfg4a7Hzaucbf99w=";
  };

  cargoHash = "sha256-tkWY+dLFDnyir6d0supR3Z202p5i4UewY+J66mL1x/o=";

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
