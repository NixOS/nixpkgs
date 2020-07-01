# currently needs to be installed into an environment and needs a `kbuildsycoca5` run afterwards for plugin discovery
{
  mkDerivation, fetchFromGitHub, lib, makeWrapper,
  cmake, extra-cmake-modules, pkgconfig,
  libkcddb, kconfig, kconfigwidgets, ki18n, kdelibs4support, kio, solid, kwidgetsaddons, kxmlgui,
  qtbase, phonon, 
  taglib,
  # optional backends
  withCD ? true, cdparanoia,
  withFlac ? true, flac,
  withMidi ? true, fluidsynth, timidity,
  withSpeex ? false, speex,
  withVorbis ? true, vorbis-tools, vorbisgain,
  withMp3 ? true, lame, mp3gain,
  withAac ? true, faad2, aacgain,
  withUnfreeAac ? false, faac,
  withFfmpeg ? true, ffmpeg-full,
  withMplayer ? false, mplayer,
  withSox ? true, sox,
  withOpus ? true, opusTools,
  withTwolame ? false, twolame,
  withApe ? false, mac,
  withWavpack ? false, wavpack
}:

assert withAac -> withFfmpeg || withUnfreeAac;
assert withUnfreeAac -> withAac;

let runtimeDeps = []
    ++ lib.optional withCD cdparanoia
    ++ lib.optional withFlac flac
    ++ lib.optional withSpeex speex
    ++ lib.optional withFfmpeg ffmpeg-full
    ++ lib.optional withMplayer mplayer
    ++ lib.optional withSox sox
    ++ lib.optional withOpus opusTools
    ++ lib.optional withTwolame twolame
    ++ lib.optional withApe mac
    ++ lib.optional withWavpack wavpack
    ++ lib.optional withUnfreeAac faac
    ++ lib.optionals withMidi [ fluidsynth timidity ]
    ++ lib.optionals withVorbis [ vorbis-tools vorbisgain ]
    ++ lib.optionals withMp3 [ lame mp3gain ]
    ++ lib.optionals withAac [  faad2 aacgain ];

in 
mkDerivation rec {
  name = "soundkonverter";
  version = "3.0.1";
  src = fetchFromGitHub {
    owner = "dfaust";
    repo = "soundkonverter";
    rev = "v" + version;
    sha256 = "1g2khdsjmsi4zzynkq8chd11cbdhjzmi37r9jhpal0b730nq9x7l";
  };
  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig kdelibs4support makeWrapper ];
  propagatedBuildInputs = [ libkcddb kconfig kconfigwidgets ki18n kdelibs4support kio solid kwidgetsaddons kxmlgui qtbase phonon];
  buildInputs = [ taglib ] ++ runtimeDeps;
  # encoder plugins go to ${out}/lib so they're found by kbuildsycoca5
  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=$out" ]; 
  sourceRoot = "source/src";
  # add runt-time deps to PATH
  postInstall = ''
    wrapProgram $out/bin/soundkonverter --prefix PATH : ${lib.makeBinPath runtimeDeps }
    '';
  meta = {
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.schmittlauch ];
    description = "Audio file converter, CD ripper and Replay Gain tool";
    longDescription = ''
      soundKonverter is a frontend to various audio converters.
      
      The key features are:
      - Audio file conversion
      - Replay Gain calculation
      - CD ripping
      
      soundKonverter supports reading and writing tags and covers for many formats, so they are preserved when converting files.
      
      It is extendable by plugins and supports many backends including:
      
      - Audio file conversion
        Backends: faac, faad, ffmpeg, flac, lame, mplayer, neroaac, timidity, fluidsynth, vorbistools, opustools, sox, twolame,
        flake, mac, shorten, wavpack and speex
        Formats: ogg vorbis, mp3, flac, wma, aac, ac3, opus, alac, mp2, als, amr nb, amr wb, ape, speex, m4a, mp1, musepack shorten,
        tta, wavpack, ra, midi, mod, 3gp, rm, avi, mkv, ogv, mpeg, mov, mp4, flv, wmv and rv
      
      - Replay Gain calculation
        Backends: aacgain, metaflac, mp3gain, vorbisgain, wvgain, mpcgain
        Formats: aac, mp3, flac, ogg vorbis, wavpack, musepack
      
      - CD ripping
        Backends: cdparanoia
      '';
  };
}
