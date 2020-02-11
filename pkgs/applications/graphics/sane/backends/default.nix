{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.28";

  src = fetchurl {
    url = "https://gitlab.com/sane-project/backends/uploads/9e718daff347826f4cfe21126c8d5091/sane-backends-${version}.tar.gz";
    sha256 = "00yy8q9hqdf0zjxxl4d8njr9zf0hhi3a9ib23ikc2anqf8zhy9ii";
  };
})
