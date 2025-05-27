{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "miniaudio";
  version = "0.11.22";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    rev = version;
    hash = "sha256-o/7sfBcrhyXEakccOAogQqm8dO4Szj1QSpaIHg6OSt4=";
  };

  installPhase = ''
    mkdir -p $out/include
    mkdir -p $out/lib/pkgconfig

    cp $src/miniaudio.h $out/include/

    echo "prefix=$out
      includedir=$out/include

      Name: miniaudio
      Description: An audio playback and capture library in a single source file.
      Version: ${version}
      Cflags: -I$out/include
      Libs: -lm -lpthread -latomic
    " > $out/lib/pkgconfig/miniaudio.pc
  '';

  meta = with lib; {
    description = "Single header audio playback and capture library written in C";
    homepage = "https://github.com/mackron/miniaudio";
    changelog = "https://github.com/mackron/miniaudio/blob/${src.rev}/CHANGES.md";
    license = with licenses; [
      unlicense # or
      mit0
    ];
    maintainers = [ maintainers.jansol ];
    platforms = platforms.all;
  };
}
