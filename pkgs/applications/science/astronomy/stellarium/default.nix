{ mkDerivation, lib, fetchFromGitHub
, cmake, freetype, libpng, libGLU_combined, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia, qtlocation, makeWrapper, qtbase
}:

mkDerivation rec {
  name = "stellarium-${version}";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    sha256 = "0srwi08azzzayf50dr4dr1zcdcc8hwribzv7xvb7hbp6xp51c813";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [
    freetype libpng libGLU_combined openssl libiconv qtscript qtserialport qttools
    qtmultimedia qtlocation qtbase makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/stellarium \
      --prefix QT_PLUGIN_PATH : "${qtbase}/lib/qt-5.${lib.versions.minor qtbase.version}/plugins"
  '';

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = http://stellarium.org/;
    license = licenses.gpl2;

    platforms = platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = with maintainers; [ peti ma27 ];
  };
}
