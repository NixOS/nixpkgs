{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost186,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanorpc";
  version = "1.1.0-unstable-2021-04-29";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "nanorpc";
    rev = "eb363c7004580d711f88ee1785d87ae6fc469220";
    hash = "sha256-glCffr7JtY5H3NbiPPnYQB10CKfU58isPz498qgKhck=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_EXAMPLE" true)
    (lib.cmakeBool "BUILD_TESTS" true)
    (lib.cmakeBool "NANORPC_PURE_CORE" true) # Requires Boost 1.67
    (lib.cmakeBool "NANORPC_WITH_SSL" false) # This option can't be enabled with NANORPC_PURE_CORE
  ];

  meta = {
    description = "NanoRPC - Modern C++ RPC library";
    homepage = "https://github.com/tdv/nanorpc";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
