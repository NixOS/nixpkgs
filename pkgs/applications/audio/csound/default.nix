{ stdenv, fetchFromGitHub, cmake, libsndfile, libsamplerate, flex, bison, boost, gettext
, alsaLib ? null
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
  name = "csound-6.08.1";
  version = "6.08.1";

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  src = fetchFromGitHub {
    owner = "csound";
    repo = "csound";
    rev = version;
    sha256 = "03xnva17sw35ga3n96x1zdfgw913dga1hccly85wzfn0kxz4rld9";
  };

  cmakeFlags = [ "-DBUILD_CSOUND_AC=0" ] # fails to find Score.hpp
    ++ stdenv.lib.optional (libjack2 != null) "-DJACK_HEADER=${libjack2}/include/jack/jack.h";

  nativeBuildInputs = [ cmake flex bison gettext ];
  buildInputs = [ libsndfile libsamplerate boost ]
    ++ builtins.filter (optional: optional != null) [
      alsaLib libpulseaudio libjack2
      liblo ladspa-sdk fluidsynth eigen
      curl tcltk fltk ];

  meta = with stdenv.lib; {
    description = "Sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = http://www.csounds.com/;
    license = licenses.gpl2;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}

