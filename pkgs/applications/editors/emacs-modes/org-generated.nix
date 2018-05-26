{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180416";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180416.tar";
          sha256 = "05rbkrs93zd9kvldwvypb8fwwaysajy5n7b2k9c8xm2cx2nayv8m";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180416";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180416.tar";
          sha256 = "1f5zdfsa1fcf66hk3w57wh5385069yg0b86h57jgkcbmxkcmj6ij";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }