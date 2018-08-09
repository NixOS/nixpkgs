{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  name = "eprover-${version}";
  version = "2.1";

  src = fetchurl {
    url = "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${version}/E.tgz";
    sha256 = "1gh99ajmza33f54idhqkdqxp5zh2k06jsf45drihnrzydlqv1n7l";
  };

  buildInputs = [ which ];

  preConfigure = ''
    sed -e 's/ *CC *= *gcc$//' -i Makefile.vars
  '';
  configureFlags = [
    "--exec-prefix=$(out)"
    "--man-prefix=$(out)/share/man"
  ];

  meta = with stdenv.lib; {
    description = "Automated theorem prover for full first-order logic with equality";
    homepage = http://www.eprover.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.all;
  };
}
