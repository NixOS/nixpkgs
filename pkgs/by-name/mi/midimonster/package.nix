{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
  gcc,
  pkg-config,
  lua5_4,
  openssl,
  jack1,
  python3,
  alsa-lib,
  ncurses,
  libevdev,
}:

stdenv.mkDerivation {
  pname = "midimonster";
  version = "0.6.0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gnumake
    gcc
    lua5_4
    openssl
    jack1
    python3
    alsa-lib
    ncurses
    libevdev
  ];

  src = fetchFromGitHub {
    repo = "midimonster";
    owner = "cbdevnet";
    rev = "f16f7db86662fcdbf45b6373257c90c824b0b4b0";
    hash = "sha256-V4vin/aYZ1nwOfHooBgxQM7bhyHRLyYO7QlrlSTRP4w=";
  };

  doCheck = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  buildPhase = ''
    PLUGINS=$out/lib/midimonster make all
  '';

  installPhase = ''
    PREFIX=$out make install

    mkdir -p "$man/share/man/man1"
    cp assets/midimonster.1 "$man/share/man/man1"

    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    cp assets/MIDIMonster.svg "$out/share/icons/hicolor/scalable/apps/"
  '';

  meta = {
    homepage = "https://midimonster.net";
    description = "Multi-protocol translation tool";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ keldu ];
    mainProgram = "midimonster";
  };
}
