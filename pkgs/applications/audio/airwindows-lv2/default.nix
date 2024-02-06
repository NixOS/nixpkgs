{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "26.2";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GpfglGC7zD275lm9OsBmqDC90E/vVUqslm7HjPgm74M=";
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
