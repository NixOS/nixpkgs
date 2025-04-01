{ python3Packages, nixosTests }:

(python3Packages.toPythonApplication python3Packages.docling-serve)
// {
  passthru.tests = {
    docling-serve = nixosTests.docling-serve;
  };
}
