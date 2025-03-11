{
  lib,
  stdenv,
  fetchsvn,
  pkg-config,
  autoreconfHook,
  bison,
  flex,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mswatch";
  # Stable release won't compile successfully
  version = "unstable-2018-11-21";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/mswatch/code/trunk";
    rev = "369";
    sha256 = "sha256-czwwhchTizfgVmeknQGLijYgaFSP/45pD2yhDKj5BKw=";
  };
  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    bison # For yacc
    flex
  ];
  buildInputs = [
    glib
  ];

  meta = with lib; {
    description = "Command-line Linux utility that efficiently directs mail synchronization between a pair of mailboxes";
    homepage = "https://mswatch.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
})
