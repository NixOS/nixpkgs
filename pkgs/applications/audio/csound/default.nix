{ stdenv, fetchurl, cmake, libsndfile, flex, bison
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
  name = "csound-6.04";

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  src = fetchurl {
    url = mirror://sourceforge/csound/Csound6.04.tar.gz;
    sha256 = "1030w38lxdwjz1irr32m9cl0paqmgr02lab2m7f7j1yihwxj1w0g";
  };

  buildInputs = [ cmake libsndfile flex bison alsaLib libpulseaudio tcltk ];

  NIX_LDFLAGS="-L${stdenv.cc.libc.out}/lib";

  meta = {
    description = "sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = http://www.csounds.com/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}

