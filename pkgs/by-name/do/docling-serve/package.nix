{
  python3Packages,
  nixosTests,
  withUI ? false,
  withTesserocr ? false,
  withRapidocr ? false,
}:

(python3Packages.toPythonApplication (
  python3Packages.docling-serve.override {
    inherit
      withUI
      withTesserocr
      withRapidocr
      ;
  }
))
// {
  passthru.tests = {
    docling-serve = nixosTests.docling-serve;
  };
}
