{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gnucap";
  version = "20210107";

  src = fetchurl {
    url = "https://git.savannah.gnu.org/cgit/gnucap.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "12rlwd4mfc54qq1wrx5k8qk578xls5z4isf94ybkf2z6qxk4mhnj";
  };

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
