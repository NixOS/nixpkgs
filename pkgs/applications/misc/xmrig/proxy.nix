{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  pname = "xmrig-proxy";
  version = "6.14.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-proxy";
    rev = "v${version}";
    sha256 = "sha256-QCjXtn7O4jcPybzMsu2j7jQqWoGzeqjwessZC/dG86s=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd openssl ];

  postPatch = ''
    # Link dynamically against libuuid instead of statically
    substituteInPlace CMakeLists.txt --replace uuid.a uuid
  '';

  installPhase = ''
    install -vD xmrig-proxy $out/bin/xmrig-proxy
  '';

  meta = with lib; {
    description = "Monero (XMR) Stratum protocol proxy";
    homepage = "https://github.com/xmrig/xmrig-proxy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aij ];
  };
}
