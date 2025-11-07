{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  fetchpatch,
  enableStatic ? stdenv.hostPlatform.isStatic,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liboqs";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = "liboqs";
    rev = finalAttrs.version;
    hash = "sha256-BJgsXbKcQjJFk/A7JvkA0NKztv0BAnkgCAXv/TM2/04=";
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

  outputs = [
    "out"
    "dev"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "C library for prototyping and experimenting with quantum-resistant cryptography";
    homepage = "https://openquantumsafe.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.sigmanificient ];
  };
})
