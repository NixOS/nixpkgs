{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
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

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  meta = {
    description = "C++ library for WebSocket client and server development";
    homepage = "https://github.com/machinezone/IXWebSocket";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
})
