{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "midisnoop";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "surfacepatterns";
    repo = "midisnoop";
    rev = "master"; # This 'master' branch has not been updated in a long time (latest commit bc30f60 from 11 years ago).
    sha256 = "sha256-XDpDfTq5sAHqeYk3j+HA9H0SGq5sawrLzdK2rqN9fv4="; # Will notify us if there is ever a change
  };

  # This ensures the compiler finds RtMidi.h
  NIX_CFLAGS_COMPILE = "-I${pkgs.rtmidi}/include/rtmidi/";

  postPatch = ''
    echo "Applying sed patches to engine.cpp and engine.h..."
    # Remove the WINDOWS_KS case
    sed -i '/case RtMidi::WINDOWS_KS:/,+2d' src/engine.cpp

    # Replace all instances of RtError with RtMidiError
    sed -i 's/RtError/RtMidiError/g' src/engine.cpp

    # Replace all instances of e.what() with e.getMessage()
    # Convert the std::string result to QString for Qt compatibility.
    sed -i 's/\.what()/\.getMessage()/g' src/engine.cpp
    sed -i 's/\(e\.getMessage()\)/QString::fromStdString(\1)/g' src/engine.cpp

    # Add #include <QObject> to engine.h at the very beginning of the file.
    # This is critical for Q_OBJECT and other Qt macros to be defined correctly.
    sed -i '1i#include <QObject>' src/engine.h

    # Fix the shebang of the Python script to use the Nix-provided python3
    echo "Fixing shebang for install/build-desktop-file..."
    sed -i "1s|.*|#!${pkgs.python3}/bin/python3|" install/build-desktop-file
  '';

  buildInputs = with pkgs; [
    libsForQt5.full
    rtmidi
    python313
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
    libsForQt5.qt5.wrapQtAppsHook
  ];

  configurePhase = ''
    python3 configure --prefix=$out
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';

  meta = with pkgs.lib; {
    description = "A simple MIDI monitor and prober";
    homepage = "https://github.com/surfacepatterns/midisnoop"; # Corrected homepage to the GitHub repository
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
