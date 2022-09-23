{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libmt32emu";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    rev = "${pname}_${lib.replaceChars [ "." ] [ "_" ] version}";
    sha256 = "sha256-XGds9lDfSiY0D8RhYG4TGyjYEVvVYuAfNSv9+VxiJEs=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  dontFixCmake = true;

  cmakeFlags = [
    "-Dmunt_WITH_MT32EMU_SMF2WAV=OFF"
    "-Dmunt_WITH_MT32EMU_QT=OFF"
  ];

  meta = with lib; {
    homepage = "http://munt.sourceforge.net/";
    description = "A library to emulate Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix; # Not tested on ReactOS yet :)
  };
}
