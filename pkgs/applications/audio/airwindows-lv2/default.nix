{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "20.0";
  src = fetchFromGitHub {
    owner = "hannesbraun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uflvUmUzOtF3BwiLfnd+qhz+ZYyn8AKvODFs599phhU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ lv2 ];

  meta = with lib; {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://github.com/hannesbraun/airwindows-lv2";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
