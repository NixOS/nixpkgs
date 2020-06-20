{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.30";

  src = fetchurl {
    url = "https://gitlab.com/sane-project/backends/uploads/c3dd60c9e054b5dee1e7b01a7edc98b0/sane-backends-${version}.tar.gz";
    sha256 = "18vryaycps3zpjzxh0wjgg8nv2f4pdvcfxxmdfj28qbzqjlrcp9z";
  };
})
