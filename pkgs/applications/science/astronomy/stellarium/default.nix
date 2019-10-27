{ mkDerivation, lib, fetchFromGitHub
, cmake, freetype, libpng, libGLU_combined, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia, qtlocation, qtbase, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "stellarium";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    sha256 = "1ki3s4smazr6xfkr0grrmjp2s8yjprismiaq7l54d0il7rkvhibd";
  };

  nativeBuildInputs = [ cmake perl wrapQtAppsHook ];

  buildInputs = [
    freetype libpng libGLU_combined openssl libiconv qtscript qtserialport qttools
    qtmultimedia qtlocation qtbase
  ];

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = http://stellarium.org/;
    license = licenses.gpl2;

    platforms = platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = with maintainers; [ peti ma27 ];
  };
}
