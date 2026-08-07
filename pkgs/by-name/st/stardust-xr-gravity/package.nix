{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-gravity";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    tag = finalAttrs.version;
    hash = "sha256-upw0MjGccSI1B10wabKPMGrEo7ATfg4a7Hzaucbf99w=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-tkWY+dLFDnyir6d0supR3Z202p5i4UewY+J66mL1x/o=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to launch apps and stardust clients at an offet";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "gravity";
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})
