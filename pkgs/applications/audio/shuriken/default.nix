{ lib
, stdenv
, pkgs
, fetchFromGitHub
, pkg-config
, alsa-lib
, aubio
, libjack2
, liblo
, libsamplerate
, libsndfile
, qmake
, qtbase
, qttools
, rtaudio
, rubberband
, wrapQtAppsHook
, mkDerivation
}:

mkDerivation rec {
  pname = "shuriken";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "rock-hopper";
    repo = "shuriken";
    rev = "v${version}";
    hash = "sha256-WpQ1XV/HLYuNj6Fgxmav8fg9i3oOjz1NipE7cL+Bedc=";
  };

  nativeBuildInputs = [
    aubio
    libjack2
    liblo
    libsamplerate
    libsndfile
    pkg-config
    qmake
    qttools
    rubberband
  ];

  buildInputs = [
    alsa-lib
    qtbase
  ];

  builder = pkgs.writeShellScript "builder.sh" ''
    source ${stdenv}/setup
    cp -a ${src} "$out"
    (
    cd "$out"
    chmod --recursive u+w .
    echo yes | bash build
    INSTALL_ROOT=$out make install
    )
  '';

  meta = with lib;
    {
      description = "Shuriken is an open source beat slicer which harnesses the power of aubio's onset detection algorithms and Rubber Band's time stretching capabilities. A simple Qt interface makes it easy to slice up drum loops, assign individual drum hits to MIDI keys, and change the tempo of loops in real-time. The JUCE library takes care of handling audio and MIDI behind the scenes.";
      homepage = "https://github.com/rock-hopper/shuriken";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with lib.maintainers; [ andrewb ];
    };
}
