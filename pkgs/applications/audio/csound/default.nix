{ stdenv, fetchurl, cmake, libsndfile, flex, bison
, alsaLib ? null
, pulseaudio ? null
, tcltk ? null

# maybe csound can be compiled with support for those, see configure output
# , ladspa ? null
# , fluidsynth ? null
# , jack ? null
# , gmm ? null
# , wiiuse ? null
}:

stdenv.mkDerivation {
  name = "csound-5.19.01";

  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/csound/Csound5.19.01.tar.gz;
    sha256 = "078i69jwgadmxwa5ffn8h1py7cmd9asa8swnh38fyp56lzgzn669";
  };

  buildInputs = [ cmake libsndfile flex bison alsaLib pulseaudio tcltk ];

  meta = {
    description = "sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = http://www.csounds.com/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}

