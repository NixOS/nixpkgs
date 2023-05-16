{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook
, alsa-lib, ladspa-sdk, lash, libarchive, libjack2, liblo, libpulseaudio, libsndfile, lrdf
, qtbase, qttools, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  pname = "hydrogen";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hydrogen-music";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-09zN6OVqVohk153gqXy6C0uHcBhZX2JJL4d6f4BU4Lg=";
=======
    sha256 = "sha256-to24PB9cs4vun93uXEWNVsmSLFRuLGfC4hCh7+mbvIo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    alsa-lib ladspa-sdk lash libarchive libjack2 liblo libpulseaudio libsndfile lrdf
    qtbase qttools qtxmlpatterns
  ];

  cmakeFlags = [
    "-DWANT_DEBUG=OFF"
  ];

  meta = with lib; {
    description = "Advanced drum machine";
    homepage = "http://www.hydrogen-music.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu orivej ];
  };
}
