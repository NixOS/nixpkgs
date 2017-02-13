{ stdenv, fetchFromGitHub, cmake, qt4, pythonPackages }:

stdenv.mkDerivation rec {
  name = "open-pdf-presenter-git-2014-09-23";

  src = fetchFromGitHub {
    owner  = "olabini";
    repo   = "open-pdf-presenter";
    rev    = "f14930871b60b6ba50298c27377605e0a5fdf124";
    sha256 = "1lfqb60zmjmsvzpbz29m8yxlzs2fscingyk8jvisng1y921726rr";
  };

  buildInputs = [ cmake qt4 pythonPackages.poppler-qt4 ];

  meta = {
    homepage = https://github.com/olabini/open-pdf-presenter;
    description = "A program for presenting PDFs on multi-monitor settings (typically a laptop connected to a overhead projector)";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
