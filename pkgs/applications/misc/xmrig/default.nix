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
  version = "6.21.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-7OHfFo8+MUNSI3vpOIODKQH41jmraHDJOyqfLBp/v9o=";
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

  # https://github.com/NixOS/nixpkgs/issues/245534
  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    mainProgram = "xmrig";
    platforms = platforms.unix;
    maintainers = with maintainers; [ kim0 ];
  };
}
