{ lib, stdenv, fetchurl, libressl,
}:

stdenv.mkDerivation rec {
  pname = "geomyidae";
  version = "0.51";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    sha512 = "3lGAa7BCrspGBcQqjduBkIACpf3u/CkeSCBnaJ3rrz3OIidn4o4dNwZNe7u8swaJxN2dhDSKKeVT3RnFQUaXdg==";
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
