{ lib, stdenv, fetchFromGitHub, cmake, libsndfile, libsamplerate, flex, bison, boost, gettext
, alsa-lib ? null
, libpulseaudio ? null
, libjack2 ? null
, liblo ? null
, ladspa-sdk ? null
, fluidsynth ? null
# , gmm ? null  # opcodes don't build with gmm 5.1
, eigen ? null
, curl ? null
, tcltk ? null
, fltk ? null
}:

stdenv.mkDerivation rec {
  pname = "csound";
  version = "6.17.0";

  hardeningDisable = [ "format" ];

  src = fetchFromGitHub {
    owner = "csound";
    repo = "csound";
    rev = version;
    sha256 = "sha256-O19jm3JxHg4TcQzWQZu1uFjfYN2FR41fCRq5YGnTGD0=";
  };

  cmakeFlags = [ "-DBUILD_CSOUND_AC=0" ] # fails to find Score.hpp
    ++ lib.optional (libjack2 != null) "-DJACK_HEADER=${libjack2}/include/jack/jack.h";

  nativeBuildInputs = [ cmake flex bison gettext ];
  buildInputs = [ libsndfile libsamplerate boost ]
    ++ builtins.filter (optional: optional != null) [
      alsa-lib libpulseaudio libjack2
      liblo ladspa-sdk fluidsynth eigen
      curl tcltk fltk ];

  meta = with lib; {
    description = "Sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = "https://csound.com/";
    license = licenses.lgpl21Plus;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}

