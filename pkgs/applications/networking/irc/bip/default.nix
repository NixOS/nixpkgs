{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, bison
, flex
, openssl
}:

stdenv.mkDerivation {
  pname = "bip";
  version = "0.9.3";

  src = fetchurl {
    # Note that the number behind download is not predictable
    url = "https://projects.duckcorp.org/attachments/download/146/bip-0.9.3.tar.gz";
    hash = "sha256-K+6AC8mg0aLQsCgiDoFBM5w2XrR+V2tfWnI8ByeRmOI=";
  };

  outputs = [ "out" "man" "doc" ];

  postPatch = ''
    # Drop blanket -Werror to avoid build failure on fresh toolchains
    # and libraries. Without the cnage build fails on gcc-13 and on
    # openssl-3.
    substituteInPlace src/Makefile.am --replace-fail ' -Werror ' ' '
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ bison flex openssl ];

  enableParallelBuilding = true;

  meta = {
    description = "IRC proxy (bouncer)";
    homepage = "http://bip.milkypond.org/";
    license = lib.licenses.gpl2;
    downloadPage = "https://projects.duckcorp.org/projects/bip/files";
    platforms = lib.platforms.linux;
  };
}
