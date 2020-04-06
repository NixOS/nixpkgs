{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "976";
  edition = "2018";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "0j6zm0cbxrcgm7glk84hvvbp4z0ys6v8bkwwhl5r7dbphyi72fw8";
  };

  archive = "office${edition}.tar.lzma";
})
