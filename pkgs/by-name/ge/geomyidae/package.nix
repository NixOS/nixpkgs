{ lib, stdenv, fetchurl, libressl,
}:

stdenv.mkDerivation rec {
  pname = "geomyidae";
  version = "0.96";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    hash = "sha256-O6zccrz5qrtvafNQvM50U2JfG42LAWJJ/DXfiDKh4dc=";
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
