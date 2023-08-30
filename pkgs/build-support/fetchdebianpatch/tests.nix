{ testers, fetchDebianPatch, ... }:

{
  simple = testers.invalidateFetcherByDrvHash fetchDebianPatch {
    pname = "pysimplesoap";
    version = "1.16.2";
    debianRevision = "5";
    patch = "Add-quotes-to-SOAPAction-header-in-SoapClient";
    hash = "sha256-xA8Wnrpr31H8wy3zHSNfezFNjUJt1HbSXn3qUMzeKc0=";
  };
}
