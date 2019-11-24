{ stdenv, fetchFromGitHub, boost, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "rc-effect-playground";
  version = "unstable-28-10-2019";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "7a0306bf0d426318195bccdd4290b7ccd284093d";
    sha256 = "14nq9p3n4lnmpdvwdr7zhsfqc1v7dyrygnzcf83hvra1z515pwrm";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    boost cairo lv2
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jpcima/rc-effect-playground;
    description = "Juno audio effect based on DISTRHO Plugin Framework";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.isc;
  };
}
