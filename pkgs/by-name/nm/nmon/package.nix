{
  fetchurl,
  lib,
  stdenv,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nmon";
  version = "16q";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${finalAttrs.version}.c";
    sha256 = "sha256-G3ioFnLBkpGz0RpuMZ3ZsjoCKiYtuh786gCNbfUaylE=";
  };

  buildInputs = [ ncurses ];
  dontUnpack = true;
  buildPhase = "${stdenv.cc.targetPrefix}cc -o nmon ${finalAttrs.src} -g -O2 -D JFS -D GETUSER -Wall -D LARGEMEM -lncurses -lm -g -D ${
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

  meta = {
    description = "AIX & Linux Performance Monitoring tool";
    mainProgram = "nmon";
    homepage = "https://nmon.sourceforge.net";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sveitser ];
  };
})
