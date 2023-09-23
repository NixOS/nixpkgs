{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "22.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u62wLRrJ45ap981Q8JmMnanc8AWQb1MJHK32PEr10I4=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ lv2 ];

  meta = with lib; {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://sr.ht/~hannes/airwindows-lv2";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
