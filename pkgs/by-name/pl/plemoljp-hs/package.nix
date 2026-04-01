{
  stdenvNoCC,
  fetchzip,
  plemoljp,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plemoljp-hs";

  # plemoljp's updateScript also updates this version.
  # nixpkgs-update: no auto update
  inherit (plemoljp) version;

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${finalAttrs.version}/PlemolJP_HS_v${finalAttrs.version}.zip";
    hash = "sha256-V21T8ktNZE4nq3SH6aN9iIJHmGTkZuMsvT84yHbwSqI=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = plemoljp.meta // {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and hidden full-width space";
  };
})
