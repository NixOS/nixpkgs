{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "eprover";
  version = "2.5";

  src = fetchurl {
    url = "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${version}/E.tgz";
    sha256 = "0jj0zkiqpcx9xp16spkskrv3jycprz7jg1g97i67j43c4yvxylwa";
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
    homepage = "http://www.eprover.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.all;
  };
}
