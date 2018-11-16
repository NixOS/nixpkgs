{ stdenv
, fetchFromGitHub
, libjack2
, qt5
, cmake
, libsndfile
, libsamplerate
, ladspaH
, fluidsynth
, alsaLib
, rtaudio
, lash
, dssi
, liblo
, pkgconfig
, gitAndTools
}:

stdenv.mkDerivation rec {
  name = "muse-sequencer-${version}";
  version = "3.0.2";

  meta = with stdenv.lib; {
    homepage = http://www.muse-sequencer.org;
    description = "MIDI/Audio sequencer with recording and editing capabilities";
    longDescription = ''
      MusE is a MIDI/Audio sequencer with recording and editing capabilities
      written originally by Werner Schweer now developed and maintained
      by the MusE development team.

      MusE aims to be a complete multitrack virtual studio for Linux,
      it is published under the GNU General Public License.
    '';
    license = stdenv.lib.licenses.gpl2;
  };

  src =
    fetchFromGitHub {
      owner = "muse-sequencer";
      repo = "muse";
      rev = "02d9dc6abd757c3c1783fdd46dacd3c4ef2c0a6d";
      sha256 = "0pn0mcg79z3bhjwxbss3ylypdz3gg70q5d1ij3x8yw65ryxbqf51";
    };


  buildInputs = [
    libjack2
    qt5.qtsvg
    qt5.qttools
    cmake
    libsndfile
    libsamplerate
    ladspaH
    fluidsynth
    alsaLib
    rtaudio
    lash
    dssi
    liblo
    pkgconfig
    gitAndTools.gitFull
  ];

  sourceRoot = "source/muse3";

  buildPhase = ''
    cd ..
    bash compile_muse.sh
  '';

  installPhase = ''
    mkdir $out
    cd build
    make install
  '';
}
