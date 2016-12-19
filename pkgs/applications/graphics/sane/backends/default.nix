{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.25";
  src = fetchurl {
    sha256 = "0b3fvhrxl4l82bf3v0j47ypjv6a0k5lqbgknrq1agpmjca6vmmx4";
    urls = [
      "http://pkgs.fedoraproject.org/repo/pkgs/sane-backends/sane-backends-${version}.tar.gz/f9ed5405b3c12f07c6ca51ee60225fe7/sane-backends-${version}.tar.gz"
      "https://alioth.debian.org/frs/download.php/file/4146/sane-backends-${version}.tar.gz"
    ];
    curlOpts = "--insecure";
  };
})
