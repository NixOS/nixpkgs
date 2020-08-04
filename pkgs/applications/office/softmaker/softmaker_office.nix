{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "1016";
  edition = "2021";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "0s8kzpc6w2cjkfqmhb2p1pkmkiq9vk9gnc7z2992kijaf9bwk3qz";
  };

  archive = "office${edition}.tar.lzma";
})
