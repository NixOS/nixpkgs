{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnop";
  version = "0-unstable-2022-09-04";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "libnop";
    rev = "ab842f51dc2eb13916dc98417c2186b78320ed10";
    sha256 = "sha256-d2z/lDI9pe5TR82MxGkR9bBMNXPvzqb9Gsd5jOv6x1A=";
  };

  patches = [
    # System install
    # https://github.com/luxonis/libnop/pull/6/commits/ae29a8772f38fdb1efc24af9ec2e3f6814eb2158.patch
    ./001-system-install.patch
    # Fix template warning
    # https://github.com/luxonis/libnop/pull/6/commits/199978a0fb0dc31de43b80f7504b53958fd202ee.patch
    ./002-fix-template-warning.patch
  ];

  nativeBuildInputs = [ gtest ];

  # Add optimization flags to address _FORTIFY_SOURCE warning
  NIX_CFLAGS_COMPILE = [ "-O1" ];

  installPhase = ''
    runHook preInstall
    make INSTALL_PREFIX=$out install
    runHook postInstall
  '';

  meta = {
    description = "Fast, header-only C++ serialization library";
    homepage = "https://github.com/google/libnop";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
