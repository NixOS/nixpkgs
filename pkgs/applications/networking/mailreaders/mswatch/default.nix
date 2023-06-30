{ lib
, stdenv
, fetchzip
, pkg-config
, autoreconfHook
, bison
, flex
, glib
}:

stdenv.mkDerivation rec {
  pname = "mswatch";
  # Stable release won't compile successfully
  version = "unstable-2018-11-21";

  src = fetchzip {
    url = "https://sourceforge.net/code-snapshots/svn/m/ms/mswatch/code/mswatch-code-r369-trunk.zip";
    hash = "sha256-czwwhchTizfgVmeknQGLijYgaFSP/45pD2yhDKj5BKw=";
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
    description = "A command-line Linux utility that efficiently directs mail synchronization between a pair of mailboxes.";
    homepage = "https://mswatch.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
}
