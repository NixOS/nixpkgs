{ stdenv, fetchurl, cmake, libsndfile, flex, bison, boost, boost-build
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

stdenv.mkDerivation {
  name = "csound-6.08.1";

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  src = fetchurl {
    url = https://github.com/csound/csound/archive/6.08.1.tar.gz;
    sha256 = "153c6c06573dd0c6989f45df1cb32ae48fb2ea942428900c0097ecc1476b82b7";
  };

  buildInputs = [ cmake libsndfile flex bison alsaLib libpulseaudio tcltk boost ];

  meta = {
    description = "Sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = http://www.csounds.com/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}

