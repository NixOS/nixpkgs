{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "srt-to-vtt-cl";
  version = "unstable-2019-01-03";

  src = fetchFromGitHub {
    owner = "nwoltman";
    repo = "srt-to-vtt-cl";
    rev = "ce3d0776906eb847c129d99a85077b5082f74724";
    hash = "sha256-FpzhWyBo9TecdZRK7FmygsrKK6WIhLf9tSbLh4DUvmM=";
  };

  patches = [
    ./fix-validation.patch
    ./simplify-macOS-builds.patch
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/srt-vtt $out/bin
  '';

  meta = {
    description = "Convert SRT files to VTT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ericdallo ];
    homepage = "https://github.com/nwoltman/srt-to-vtt-cl";
    platforms = lib.platforms.unix;
    mainProgram = "srt-vtt";
  };
}
