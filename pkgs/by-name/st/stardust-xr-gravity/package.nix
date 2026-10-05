{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-gravity";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    tag = finalAttrs.version;
    hash = "sha256-+AJZILI157bo2otxm3Plftgk4AsGZiajvOcKmzJxFy8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-ykhRbPOftWVo2jN22cwMppSnxFus7ac1uKZBm5cFRpQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to launch apps and stardust clients at an offset";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "gravity";
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})
