{ mkDerivation, lib, fetchFromGitHub, cmake, substituteAll
, qtscript, qttranslations, qtwebengine, gdal, proj, routino, quazip }:

mkDerivation rec {
  pname = "qmapshack";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = pname;
    rev = "V_${version}";
    sha256 = "1yzgkdjxwyg8ggbxyjwr0zjrx99ckrbz2p2524iii9i7qqn8wfsx";
  };

  patches = [
    # See https://github.com/NixOS/nixpkgs/issues/86054
    (substituteAll {
      src = ./fix-qttranslations-path.patch;
      inherit qttranslations;
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtscript qtwebengine gdal proj routino quazip ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ gdal routino ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/Maproom/qmapshack";
    description = "Consumer grade GIS software";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda sikmir ];
    platforms = with platforms; linux;
  };
}
