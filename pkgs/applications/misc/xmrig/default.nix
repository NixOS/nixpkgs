{ stdenv
, lib
, fetchFromGitHub
, cmake
, libuv
, libmicrohttpd
, openssl
, hwloc
, donateLevel ? 0
, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks) Carbon CoreServices OpenCL;
in
stdenv.mkDerivation rec {
  pname = "xmrig";
  version = "6.19.3";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-mvEmxN7spyQkavAcjW4bVt7xjtRTP77OwHzJ5UqsSoE=";
  };

  patches = [
    ./donate-level.patch
  ];

  postPatch = ''
    substituteAllInPlace src/donate.h
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
    hwloc
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    CoreServices
    OpenCL
  ];

  inherit donateLevel;

  installPhase = ''
    runHook preInstall

    install -vD xmrig $out/bin/xmrig

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kim0 ];
  };
}
