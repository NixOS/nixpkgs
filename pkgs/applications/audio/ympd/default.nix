{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libmpdclient
, openssl
}:

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
  buildInputs = [ libmpdclient openssl ];

  meta = with lib; {
    homepage = "https://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ maintainers.siddharthist ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
