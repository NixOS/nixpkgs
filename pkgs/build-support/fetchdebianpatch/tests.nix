{ testers, fetchDebianPatch, ... }:

{
  simple = testers.invalidateFetcherByDrvHash fetchDebianPatch {
    pname = "pysimplesoap";
    version = "1.16.2";
    debianRevision = "5";
    patch = "Add-quotes-to-SOAPAction-header-in-SoapClient";
    hash = "sha256-xA8Wnrpr31H8wy3zHSNfezFNjUJt1HbSXn3qUMzeKc0=";
  };

  libPackage = testers.invalidateFetcherByDrvHash fetchDebianPatch {
    pname = "libfile-pid-perl";
    version = "1.01";
    debianRevision = "2";
    patch = "missing-pidfile";
    hash = "sha256-VBsIYyCnjcZLYQ2Uq2MKPK3kF2wiMKvnq0m727DoavM=";
  };
}
