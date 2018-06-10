{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  name = "eprover-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${version}/E.tgz";
    sha256 = "1xmwr32pd8lv3f6yh720mdqhi3na505y3zbgcsgh2hwb7b5i3ngb";
  };

  buildInputs = [ which ];

  preConfigure = ''
    sed -e 's/ *CC *= *gcc$//' -i Makefile.vars
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
