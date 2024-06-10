{ stdenv
, lib
, fetchFromGitHub
, cmake
, libuv
, libmicrohttpd
, openssl
, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks) CoreServices IOKit;
in
stdenv.mkDerivation rec {
  pname = "xmrig-proxy";
  version = "6.21.1";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-proxy";
    rev = "v${version}";
    hash = "sha256-70SYdO3uyPINanAoARd2lDwyiuc2f/gg4QuoDgoXjjs=";
  };

  postPatch = ''
    # Link dynamically against libraries instead of statically
    substituteInPlace CMakeLists.txt \
      --replace uuid.a uuid
    substituteInPlace cmake/OpenSSL.cmake \
      --replace "set(OPENSSL_USE_STATIC_LIBS TRUE)" "set(OPENSSL_USE_STATIC_LIBS FALSE)"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libuv
    libmicrohttpd
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    IOKit
  ];

  installPhase = ''
    runHook preInstall

    install -vD xmrig-proxy $out/bin/xmrig-proxy

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monero (XMR) Stratum protocol proxy";
    mainProgram = "xmrig-proxy";
    homepage = "https://github.com/xmrig/xmrig-proxy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aij ];
  };
}
