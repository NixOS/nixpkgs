{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "1014";
  edition = "2021";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "0wqaxng6s7lxwz6v2j6y1m5h4g4v63m0lscj7l2fpx5ksjlamp55";
  };

  archive = "office${edition}.tar.lzma";
})
