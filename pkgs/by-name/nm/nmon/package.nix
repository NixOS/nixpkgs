{
  fetchurl,
  lib,
  stdenv,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nmon";
  version = "16s";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${finalAttrs.version}.c";
    hash = "sha256-BzbOD3KeSMEkp7pWbAacWiNFEcycasknfakvi7RPKxE=";
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
