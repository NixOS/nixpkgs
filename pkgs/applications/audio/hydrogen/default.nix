{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook
, alsaLib, ladspa-sdk, lash, libarchive, libjack2, liblo, libpulseaudio, libsndfile, lrdf
, qtbase, qttools, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  pname = "hydrogen";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hydrogen-music";
    repo = pname;
    rev = version;
    sha256 = "0snljpvbcgikhz610c325dgvayi0k512p3bglck9vvi90wsqx7l1";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    alsaLib ladspa-sdk lash libarchive libjack2 liblo libpulseaudio libsndfile lrdf
    qtbase qttools qtxmlpatterns
  ];

  cmakeFlags = [
    "-DWANT_DEBUG=OFF"
  ];

  meta = with lib; {
    description = "Advanced drum machine";
    homepage = "http://www.hydrogen-music.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu orivej ];
  };
}
