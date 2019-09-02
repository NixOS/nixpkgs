{ mkDerivation, lib, fetchFromGitHub
, cmake, freetype, libpng, libGLU_combined, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia, qtlocation, qtbase, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "stellarium";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    sha256 = "0hf1wv2bb5j7ny2xh29mj9m4hjblhn02zylay8gl85w7xlqs7s5r";
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
