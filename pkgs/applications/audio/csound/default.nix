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
  name = "csound5.18.02";

  enableParallelBuilding = true;

  src = fetchurl {
    url = http://netcologne.dl.sourceforge.net/project/csound/csound5/csound5.18/Csound5.18.02.tar.gz;
    sha256 = "4c461cf3bf60b83671224949dd33805379b7121bf2c0ad6af5e191e7f6f8adc8";
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

