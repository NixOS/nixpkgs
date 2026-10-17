{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  cmake,
  zlib,
  useTLS ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ixwebsocket";
  version = "12.0.1";
  src = fetchFromGitHub {
    owner = "machinezone";
    repo = "IXWebSocket";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2QWIpLVIs2vGuMEhewDyihYdDQBz7SsOtfZ6pE67j2Q=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ]
  ++ lib.optional useTLS (lib.cmakeBool "USE_TLS" true);

  strictDeps = true;
  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optional useTLS openssl;

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/machinezone/IXWebSocket";
    description = "C++ library for WebSocket client and server development";
    longDescription = ''
      IXWebSocket is a C++ library for WebSocket client and server development. It has minimal dependencies (no boost), is very simple to use and support everything you'll likely need for websocket dev (SSL, deflate compression, compiles on most platforms, etc...).
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mysaa ];
  };
})
