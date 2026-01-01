{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "materia-kde-theme";
  version = "20220714";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "materia-kde";
    rev = version;
    sha256 = "sha256-/LA+H2ekxuO1RpfaPJruRGeWPVopA0rZUxU4Mh7YQ0s=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.diffumist ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.diffumist ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
