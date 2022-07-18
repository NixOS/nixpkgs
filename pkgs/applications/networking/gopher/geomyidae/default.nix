{ lib, stdenv, fetchurl, libressl,
}:

stdenv.mkDerivation rec {
  pname = "geomyidae";
  version = "0.50.1";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    sha512 = "2a71b12f51c2ef8d6e791089f9eea49eb90a36be45b874d4234eba1e673186be945711be1f92508190f5c0a6f502f132c4b7cb82caf805a39a3f31903032ac47";
  };

  buildInputs = [ libressl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A gopher daemon for Linux/BSD";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = licenses.mit;
    maintainers = [ maintainers.athas ];
    platforms = platforms.unix;
  };
}
