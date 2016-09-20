{ stdenv, fetchurl, which }:
stdenv.mkDerivation rec {
  name = "eprover-${version}";
  version = "1.9.1";

  src = fetchurl {
    url = "http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${version}/E.tgz";
    sha256 = "1vi977mdfqnj04m590aw4896nqzlc4c5rqadjzk86z1zvj7mqnqw";
  };

  buildInputs = [ which ];

  preConfigure = ''
    sed -e 's/ *CC *= gcc$//' -i Makefile.vars
  '';
  configureFlags = "--exec-prefix=$(out) --man-prefix=$(out)/share/man";

  postInstall = ''
    sed -e s,EXECPATH=.\*,EXECPATH=$out/bin, -i $out/bin/eproof{,_ram}
  '';

  meta = with stdenv.lib; {
    description = "Automated theorem prover for full first-order logic with equality";
    homepage = http://www.eprover.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.all;
  };
}
