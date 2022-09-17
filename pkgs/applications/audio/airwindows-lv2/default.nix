{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "5.0";
  src = fetchFromGitHub {
    owner = "hannesbraun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sLkcEEYez0Z3pkhMCC7raiwe/m9Tk/lFmOuybZvFqSk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ lv2 ];

  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/lib/lv2" ];

  meta = with lib; {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://github.com/hannesbraun/airwindows-lv2";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
