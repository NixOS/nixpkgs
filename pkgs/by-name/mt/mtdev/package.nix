{
  lib,
  stdenv,
  fetchurl,
  evdev-proto,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "mtdev";
  version = "1.1.7";

  src = fetchurl {
    url = "https://bitmath.org/code/mtdev/${pname}-${version}.tar.bz2";
    hash = "sha256-oQetrSEB/srFSsf58OCg3RVdlUGT2lXCNAyX8v8dgU4=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isFreeBSD evdev-proto;

  passthru.updateScript = gitUpdater {
    url = "https://bitmath.org/git/mtdev.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://bitmath.org/code/mtdev/";
    description = "Multitouch Protocol Translation Library";
    mainProgram = "mtdev-test";
    longDescription = ''
      The mtdev is a stand-alone library which transforms all variants of
      kernel MT events to the slotted type B protocol. The events put into
      mtdev may be from any MT device, specifically type A without contact
      tracking, type A with contact tracking, or type B with contact tracking.
      See the kernel documentation for further details.
    '';
    license = licenses.mit;
    platforms = with platforms; freebsd ++ linux;
  };
}
