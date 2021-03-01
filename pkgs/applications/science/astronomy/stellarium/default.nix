{ stdenv, lib, mkDerivation, fetchFromGitHub
, cmake, freetype, libpng, libGLU, libGL, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia, qtlocation, qtbase, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "stellarium";
  version = "0.20.4";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    sha256 = "sha256-EhlcaMxlDyX2RneBrpbmLScc9vd77Tf7RPblbQqAqZ0=";
  };

  nativeBuildInputs = [ cmake perl wrapQtAppsHook ];

  buildInputs = [
    freetype libpng libGLU libGL openssl libiconv qtscript qtserialport qttools
    qtmultimedia qtlocation qtbase
  ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace 'SET(CMAKE_INSTALL_PREFIX "''${PROJECT_BINARY_DIR}/Stellarium.app/Contents")' \
                'SET(CMAKE_INSTALL_PREFIX "${placeholder "out"}/Stellarium.app/Contents")'
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    wrapQtApp "$out"/Stellarium.app/Contents/MacOS/stellarium
  '';

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ peti ma27 ];
  };
}
