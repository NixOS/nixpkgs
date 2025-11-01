{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  cmake,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "portmidi";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "portmidi";
    repo = "portmidi";
    rev = "v${version}";
    sha256 = "sha256-kmyjOsjLG56Qqrf6DqgOTpt4A4aCMvCI3koiUoKzwrE=";
  };

  cmakeFlags = [
    "-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=Release"
  ];

  postInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      ln -s libportmidi${ext} "$out/lib/libporttime${ext}"
    '';

  nativeBuildInputs = [
    unzip
    cmake
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/PortMidi/portmidi";
    description = "Platform independent library for MIDI I/O";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
