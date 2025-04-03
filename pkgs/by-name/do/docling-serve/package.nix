{
  python3Packages,
  nixosTests,
  withUI ? false,
}:

(python3Packages.toPythonApplication (python3Packages.docling-serve.override { inherit withUI; }))
// {
  passthru.tests = {
    docling-serve = nixosTests.docling-serve;
  };
}
