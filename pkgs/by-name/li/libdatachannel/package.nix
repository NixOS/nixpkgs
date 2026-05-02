{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  libnice,
  openssl,
  plog,
  srtp,
  usrsctp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdatachannel";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libdatachannel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+4Vkw3Oej7jfr5MM1sCAIrQRFUxXTAW+V1BrZjSxtp0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    libnice
    openssl
    srtp
    usrsctp
    plog
  ];

  cmakeFlags = [
    "-DUSE_NICE=ON"
    "-DPREFER_SYSTEM_LIB=ON"
    "-DNO_EXAMPLES=ON"
  ];

  postFixup = ''
    # Fix include path that will be incorrect due to the "dev" output
    substituteInPlace "$dev/lib/cmake/LibDataChannel/LibDataChannelTargets.cmake" \
      --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '';

  meta = {
    description = "C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets";
    homepage = "https://libdatachannel.org/";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ erdnaxe ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
