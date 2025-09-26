{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  pam,
}:

stdenv.mkDerivation rec {
  pname = "pamtester";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/pamtester/pamtester-${version}.tar.gz";
    sha256 = "1mdj1wj0adcnx354fs17928yn2xfr1hj5mfraq282dagi873sqw3";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ pam ];

  meta = with lib; {
    description = "Utility program to test the PAM facility";
    mainProgram = "pamtester";
    homepage = "https://pamtester.sourceforge.net/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
