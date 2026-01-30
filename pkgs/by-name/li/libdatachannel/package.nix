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
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libdatachannel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-76rlnO0wr7xQAGCc0GmpHQldzHKnZ8NZWpHmrE70h/c=";
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
