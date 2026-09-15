{
  lib,
  pdfium,
  runCommandCC,
}:

runCommandCC "pdfium-integration-test" { } ''
  $CC \
    -I${lib.getDev pdfium}/include/public \
    ${./integration.c} \
    -L${lib.getLib pdfium}/lib \
    -lpdfium \
    -o pdfium-integration-test

  ./pdfium-integration-test
  touch $out
''
