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

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: CMakeFiles/ympd.dir/src/mpd_client.c.o:(.bss+0x0): multiple definition of `mpd';
  #     CMakeFiles/ympd.dir/src/ympd.c.o:(.bss+0x20): first defined here
  # Should be fixed by pending https://github.com/notandy/ympd/pull/191 (does not apply as is).
  NIX_CFLAGS_COMPILE = "-fcommon";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libmpdclient openssl ];

  meta = with lib; {
    homepage = "https://github.com/notandy/ympd";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ maintainers.siddharthist ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
