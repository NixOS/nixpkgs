{ lib, stdenv, fetchurl, which, enableHO ? false }:

stdenv.mkDerivation rec {
  pname = "eprover";
  version = "3.0.03";

  src = fetchurl {
    url = "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${version}/E.tgz";
    hash = "sha256-cS5zUe2N9Kd9uzbNpeBtvLbgUN0c3N3tGcYczK3KsdQ=";
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
