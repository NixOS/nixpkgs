{
  cmake,
  pdfium,
  runCommandCC,
}:

runCommandCC "pdfium-cmake-test"
  {
    nativeBuildInputs = [ cmake ];
    buildInputs = [ pdfium ];
  }
  ''
    cmake -S ${./.} -B build
    cmake --build build

    ./build/pdfium-integration-test
    touch $out
  ''
