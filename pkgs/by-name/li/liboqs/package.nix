{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  fetchpatch,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liboqs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = "liboqs";
    rev = finalAttrs.version;
    hash = "sha256-BFDa5NUr02lFPcT4Hnb2rjGAi+2cXvh1SHLfqX/zLlI=";
  };

  patches = [
    ./fix-openssl-detection.patch
    # liboqs.pc.in path were modified in this commit
    # causing malformed path with double slashes.
    (fetchpatch {
      url = "https://github.com/open-quantum-safe/liboqs/commit/f0e6b8646c5eae0e8052d029079ed3efa498f220.patch";
      hash = "sha256-tDfWzcDnFGikzq2ADEWiUgcUt1NSLWQ9/HVWA3rKuzc=";
      revert = true;
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}"
    "-DOQS_DIST_BUILD=ON"
    "-DOQS_BUILD_ONLY_LIB=ON"
  ];

  dontFixCmake = true; # fix CMake file will give an error

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "C library for prototyping and experimenting with quantum-resistant cryptography";
    homepage = "https://openquantumsafe.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.sigmanificient ];
  };
})
