{ lib
, stdenv
, fetchurl
, readline
, termcap
}:

stdenv.mkDerivation rec {
  pname = "gnucap";
  version = "20240130-dev";

  src = fetchurl {
    url = "https://git.savannah.gnu.org/cgit/gnucap.git/snapshot/${pname}-${version}.tar.gz";
    hash = "sha256-MUCtGw3BxGWgXgUwzklq5T1y9kjBTnFBa0/GK0hhl0E=";
  };

  buildInputs = [
    readline
    termcap
  ];

  doCheck = true;

  meta = with lib; {
    description = "Gnu Circuit Analysis Package";
    longDescription = ''
Gnucap is a modern general purpose circuit simulator with several advantages over Spice derivatives.
It performs nonlinear dc and transient analyses, fourier analysis, and ac analysis.
    '';
    homepage = "http://www.gnucap.org/";
    changelog = "https://git.savannah.gnu.org/cgit/gnucap.git/plain/NEWS?h=v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    broken = stdenv.isDarwin; # Relies on LD_LIBRARY_PATH
    maintainers = [ maintainers.raboof ];
  };
}
