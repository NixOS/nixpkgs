{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.27";
  src = fetchurl {
    sha256 = "1j9nbqspaj0rlgalafb5z6r606k0i22kz0rcpd744p176yzlfdr9";
    urls = [
      "https://alioth-archive.debian.org/releases/sane/sane-backends/${version}/sane-backends-${version}.tar.gz"
    ];
  };
})
