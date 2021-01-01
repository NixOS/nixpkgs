{ stdenv, fetchFromGitHub, cmake, pkg-config, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  pname = "ympd";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "notandy";
    repo = "ympd";
    rev = "v${version}";
    sha256 = "1nvb19jd556v2h2bi7w4dcl507p3p8xvjkqfzrcsy7ccy3502brq";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ mpd_clientlib openssl ];

  meta = {
    homepage = "https://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
  };
}
