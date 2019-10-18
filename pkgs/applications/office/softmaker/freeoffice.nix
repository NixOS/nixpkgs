{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "971";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "1h36pjbpbiy4cw383cbrwh1jx2kp1ay29734zailmhifz53gj44f";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
