{
  lib,
  stdenv,
  fetchurl,
  libressl,
}:

stdenv.mkDerivation rec {
  pname = "geomyidae";
  version = "0.69";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    hash = "sha256-C0mAjyS2wZVipXP/sKxa/d7gDyYQ/MvmwqQ/QMzmcRE=";
  };

  buildInputs = [ libressl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Gopher daemon for Linux/BSD";
    mainProgram = "geomyidae";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = licenses.mit;
    maintainers = [ maintainers.athas ];
    platforms = platforms.unix;
  };
}
