{
  python3Packages,
  nixosTests,
  withUI ? false,
  withTesserocr ? false,
  withRapidocr ? false,
  withCPU ? false,
}:

(python3Packages.toPythonApplication (
  python3Packages.docling-serve.override {
    inherit
      withUI
      withTesserocr
      withRapidocr
      withCPU
      ;
  }
)).overrideAttrs
  (old: {
    passthru = old.passthru or { } // {
      tests = old.passthru.tests or { } // {
        inherit (nixosTests) docling-serve;
      };
    };
  })
