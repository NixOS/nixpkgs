{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  python3,
  util-linux,
  which,

  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxsmm";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "libxsmm";
    repo = "libxsmm";
    rev = finalAttrs.version;
    sha256 = "sha256-s/NEFU4IwQPLyPLwMmrrpMDd73q22Sk2BNid/kedawY=";
  };

  # Fixes /build references in the rpath
  patches = [ ./rpath.patch ];

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    gfortran
    python3
    util-linux
    which
  ];

  enableParallelBuilding = true;

  dontConfigure = true;

  makeFlags =
    let
      static = if enableStatic then "1" else "0";
    in
    [
      "OMP=1"
      "PREFIX=$(out)"
      "STATIC=${static}"
    ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int -std=gnu17";

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    mv $out/lib/*.pc $dev/lib/pkgconfig

    moveToOutput "share/libxsmm" ''${!outputDoc}
  '';

  prePatch = ''
    patchShebangs .
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Library targeting Intel Architecture for specialized dense and sparse matrix operations, and deep learning primitives";
    mainProgram = "libxsmm_gemm_generator";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/hfp/libxsmm";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chessai ];
  };
})
