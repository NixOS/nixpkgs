{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "materia-kde-theme";
  version = "20220714";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "materia-kde";
    rev = finalAttrs.version;
    sha256 = "sha256-/LA+H2ekxuO1RpfaPJruRGeWPVopA0rZUxU4Mh7YQ0s=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.diffumist ];
    platforms = lib.platforms.all;
  };
})
