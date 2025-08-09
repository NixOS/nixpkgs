{
  fetchurl,
  lib,
  stdenv,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "nmon";
  version = "16q";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${version}.c";
    sha256 = "sha256-G3ioFnLBkpGz0RpuMZ3ZsjoCKiYtuh786gCNbfUaylE=";
  };

  buildInputs = [ ncurses ];
  dontUnpack = true;
  buildPhase = "${stdenv.cc.targetPrefix}cc -o nmon ${src} -g -O2 -D JFS -D GETUSER -Wall -D LARGEMEM -lncurses -lm -g -D ${
    with stdenv.hostPlatform;
    if isx86 then
      "X86"
    else if isAarch then
      "ARM"
    else if isPower then
      "POWER"
    else
      "UNKNOWN"
  }";
  installPhase = ''
    mkdir -p $out/bin
    cp nmon $out/bin
  '';

  meta = with lib; {
    description = "AIX & Linux Performance Monitoring tool";
    mainProgram = "nmon";
    homepage = "https://nmon.sourceforge.net";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sveitser ];
  };
}
