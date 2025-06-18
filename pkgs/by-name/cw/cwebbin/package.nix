{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  tie,
}:

let
  cweb = fetchurl {
    url = "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64ah.tgz";
    sha256 = "1hdzxfzaibnjxjzgp6d2zay8nsarnfy9hfq55hz1bxzzl23n35aj";
  };
in
stdenv.mkDerivation rec {
  pname = "cwebbin";
  version = "22p";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ascherer";
    repo = "cwebbin";
    rev = "2016-05-20-22p";
    sha256 = "0zf93016hm9i74i2v384rwzcw16y3hg5vc2mibzkx1rzvqa50yfr";
  };

  prePatch = ''
    tar xf ${cweb}
  '';

  # Remove references to __DATE__ and __TIME__
  postPatch = ''
    substituteInPlace wmerg-patch.ch --replace ' ("__DATE__", "__TIME__")' ""
    substituteInPlace ctang-patch.ch --replace ' ("__DATE__", "__TIME__")' ""
    substituteInPlace ctangle.cxx --replace ' ("__DATE__", "__TIME__")' ""
    substituteInPlace cweav-patch.ch --replace ' ("__DATE__", "__TIME__")' ""
  '';

  nativeBuildInputs = [ tie ];

  makefile = "Makefile.unix";

  makeFlags = [
    "MACROSDIR=$(out)/share/texmf/tex/generic/cweb"
    "CWEBINPUTS=$(out)/lib/cweb"
    "DESTDIR=$(out)/bin/"
    "MANDIR=$(out)/share/man/man1"
    "EMACSDIR=$(out)/share/emacs/site-lisp"
    "CP=cp"
    "RM=rm"
    "PDFTEX=echo"
    # requires __structuredAttrs = true
    "CC=$(CXX) -std=c++14"
  ];

  buildFlags = [
    "boot"
    "cautiously"
  ];

  preInstall = ''
    mkdir -p $out/share/man/man1 $out/share/texmf/tex/generic $out/share/emacs $out/lib
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Literate Programming in C/C++";
    platforms = with platforms; unix;
    maintainers = [ ];
    license = licenses.abstyles;
  };
}
