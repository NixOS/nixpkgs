{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rpclib";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "rpclib";
    repo = "rpclib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6RFFiJ/xMhJ5sSvmT67WKLtdeSh8JLt4n060fwidizY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "RPC library for C++, providing both a client and server implementation";
    homepage = "https://github.com/rpclib/rpclib/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tmplt ];
  };
})
