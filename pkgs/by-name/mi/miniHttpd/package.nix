{
  lib,
  stdenv,
  fetchurl,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "mini-httpd";
  version = "1.7";

  src = fetchurl {
    url = "https://download-mirror.savannah.gnu.org/releases/mini-httpd/${pname}-${version}.tar.gz";
    sha256 = "0jggmlaywjfbdljzv5hyiz49plnxh0har2bnc9dq4xmj1pmjgs49";
  };

  buildInputs = [ boost ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  meta = with lib; {
    homepage = "http://mini-httpd.nongnu.org/";
    description = "minimalistic high-performance web server";
    mainProgram = "httpd";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
