{
  stdenv,
  pkg-config,
  mkl-gnulibs,
}:

stdenv.mkDerivation {
  pname = "mkl-gnulibs-test";
  version = mkl-gnulibs.version;

  unpackPhase = ''
    cp ${./test.c} test.c
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ mkl-gnulibs ];

  doCheck = true;

  buildPhase = ''
    gcc test.c -o test $(pkg-config --cflags --libs mkl_rt) -fopenmp
  '';

  installPhase = ''
    touch $out
  '';

  checkPhase = ''
    ./test
  '';
}
