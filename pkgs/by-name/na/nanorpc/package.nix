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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "nanorpc";
    rev = "eb363c7004580d711f88ee1785d87ae6fc469220";
    #rev = "${finalAttrs.version}";
    hash = "sha256-glCffr7JtY5H3NbiPPnYQB10CKfU58isPz498qgKhck";
  };

  patches = [ ./0001-cmake-install-package-details-into-system.patch ];

  nativeBuildInputs = [ cmake ];
  #buildInputs = [ boost186 openssl ];
  buildInputs = [ ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF" # Disable examples by default
    "-DBUILD_TESTS=OFF" # Disable tests by default
    "-DNANORPC_PURE_CORE=ON" # Skip Boost
    "-DNANORPC_WITH_SSL=OFF" # Skip OpenSSL
  ];

  meta = {
    description = "NanoRPC - Modern C++ RPC library";
    homepage = "https://github.com/tdv/nanorpc";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
