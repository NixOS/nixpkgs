<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtscript, qtwebengine, gdal, proj, routino, quazip }:

stdenv.mkDerivation rec {
  pname = "qmapshack";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    rev = "V_${version}";
    hash = "sha256-qG/fiR2J5wQZaR+xvBGjdp3L7viqki2ktkzBUf6fZi8=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
=======
{ mkDerivation, lib, fetchFromGitHub, cmake, substituteAll
, qtscript, qttranslations, qtwebengine, gdal, proj, routino, quazip }:

mkDerivation rec {
  pname = "qmapshack";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = pname;
    rev = "V_${version}";
    sha256 = "sha256-2otvRKtFb51PLrIh/Hxltp69n5nyR63HGGvk73TFjqA=";
  };

  patches = [
    # See https://github.com/NixOS/nixpkgs/issues/86054
    (substituteAll {
      src = ./fix-qttranslations-path.patch;
      inherit qttranslations;
    })
  ];

  nativeBuildInputs = [ cmake ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ qtscript qtwebengine gdal proj routino quazip ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ gdal routino ]}"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Consumer grade GIS software";
    homepage = "https://github.com/Maproom/qmapshack";
    changelog = "https://github.com/Maproom/qmapshack/blob/V_${version}/changelog.txt";
=======
    homepage = "https://github.com/Maproom/qmapshack";
    description = "Consumer grade GIS software";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda sikmir ];
    platforms = with platforms; linux;
  };
}
