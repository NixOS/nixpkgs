{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  fftw,
  fftwFloat,
  python3,
  datatype ? "double",
  libpng,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableOpenmp ? false,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kissfft-${datatype}${lib.optionalString enableOpenmp "-openmp"}";
  version = "131.1.0";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "mborgerding";
    repo = "kissfft";
    rev = finalAttrs.version;
    hash = "sha256-ukikTVnmKomKXTo6zc+PhpZzEkzXN2imFwZOYlfR3Pk=";
  };

  patches = [
    # Fix FFTW dependency check
    # https://github.com/mborgerding/kissfft/pull/95
    ./fix-fftw-dependency-check.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs =
    lib.optionals (datatype != "simd") [ libpng ]
    # TODO: This may mismatch the LLVM version in the stdenv, see #79818.
    ++ lib.optional (enableOpenmp && stdenv.cc.isClang) llvmPackages.openmp;

  nativeCheckInputs = [ (python3.withPackages (ps: [ ps.numpy ])) ];

  checkInputs = [ (if datatype == "float" then fftwFloat else fftw) ];

  cmakeFlags = [
    (lib.cmakeFeature "KISSFFT_DATATYPE" datatype)
    (lib.cmakeBool "KISSFFT_STATIC" enableStatic)
    # `test/testkiss.py` expects this…
    (lib.cmakeFeature "KISSFFT_OPENMP" (if enableOpenmp then "ON" else "OFF"))
  ];

  # Required for `test/testcpp.c`.
  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D__MATH_LONG_DOUBLE_CONSTANTS=1";
  };

  doCheck = true;

  # https://bugs.llvm.org/show_bug.cgi?id=45034
  postPatch =
    lib.optionalString
      (stdenv.hostPlatform.isLinux && stdenv.cc.isClang && lib.versionOlder stdenv.cc.version "10")
      ''
        substituteInPlace CMakeLists.txt \
          --replace "-ffast-math" ""
      '';

  meta = {
    description = "Mixed-radix Fast Fourier Transform based up on the KISS principle";
    homepage = "https://github.com/mborgerding/kissfft";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
