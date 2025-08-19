{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  python3,

  # Enable BLAS interface with 64-bit integer width.
  blas64 ? false,

  # Target architecture. x86_64 builds Intel and AMD kernels.
  withArchitecture ? "x86_64",

  # Enable OpenMP-based threading.
  withOpenMP ? true,
}:

let
  blasIntSize = if blas64 then "64" else "32";
in
stdenv.mkDerivation rec {
  pname = "blis";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "flame";
    repo = "blis";
    rev = version;
    sha256 = "sha256-+n8SbiiEJDN4j1IPmZfI5g1i2J+jWrUXh7S48JEDTAE=";
  };

  inherit blas64;

  nativeBuildInputs = [
    perl
    python3
  ];

  doCheck = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-cblas"
    "--blas-int-size=${blasIntSize}"
  ]
  ++ lib.optionals withOpenMP [ "--enable-threading=openmp" ]
  ++ [ withArchitecture ];

  postPatch = ''
    patchShebangs configure build/flatten-headers.py
  '';

  postInstall = ''
    ln -s $out/lib/libblis.so.4 $out/lib/libblas.so.3
    ln -s $out/lib/libblis.so.4 $out/lib/libcblas.so.3
    ln -s $out/lib/libblas.so.3 $out/lib/libblas.so
    ln -s $out/lib/libcblas.so.3 $out/lib/libcblas.so
  '';

  meta = with lib; {
    description = "BLAS-compatible linear algebra library";
    homepage = "https://github.com/flame/blis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stephen-huan ];
    platforms = [ "x86_64-linux" ];
  };
}
