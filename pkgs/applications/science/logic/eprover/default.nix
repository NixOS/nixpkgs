{ lib, stdenv, fetchurl, which, enableHO ? false }:

stdenv.mkDerivation rec {
  pname = "eprover";
  version = "2.6";

  src = fetchurl {
    url = "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${version}/E.tgz";
    sha256 = "sha256-qh896qIpFR5g1gdWAwGkbNJLBqUQCeCpuoYHHkDXPt0=";
  };

  buildInputs = [ which ];

  preConfigure = ''
    sed -e 's/ *CC *= *gcc$//' -i Makefile.vars
  '';
  configureFlags = [
    "--exec-prefix=$(out)"
    "--man-prefix=$(out)/share/man"
  ] ++ lib.optionals enableHO [
    "--enable-ho"
  ];

  meta = with lib; {
    description = "Automated theorem prover for full first-order logic with equality";
    homepage = "http://www.eprover.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.all;
  };
}
