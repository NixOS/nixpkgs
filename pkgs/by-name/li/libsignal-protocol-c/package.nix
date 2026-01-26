{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsignal-protocol-c";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal-protocol-c";
    rev = "v${finalAttrs.version}";
    sha256 = "0z5p03vk15i6h870azfjgyfgxhv31q2vq6rfhnybrnkxq2wqzwhk";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Signal Protocol C Library";
    homepage = "https://github.com/signalapp/libsignal-protocol-c";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
