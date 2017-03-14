{ stdenv, fetchFromGitHub, cmake, libsndfile, flex, bison, boost
, alsaLib ? null
, libpulseaudio ? null
, tcltk ? null

# maybe csound can be compiled with support for those, see configure output
# , ladspa ? null
# , fluidsynth ? null
# , jack ? null
# , gmm ? null
# , wiiuse ? null
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

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ libsndfile alsaLib libpulseaudio tcltk boost ];

  meta = with stdenv.lib; {
    description = "Sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = http://www.csounds.com/;
    license = licenses.gpl2;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}

