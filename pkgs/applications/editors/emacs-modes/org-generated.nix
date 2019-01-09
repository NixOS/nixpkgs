{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20181217";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20181217.tar";
          sha256 = "0j301z0429dnk1d3bn7524y848vp9il41sxpm9z9hs7gpzfdcw28";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org-plus-contrib";
        ename = "org-plus-contrib";
        version = "20181217";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20181217.tar";
          sha256 = "1p7v9246zxkp68kc63550x3w7pmhx1drgj20wmddhvs0bqd3k3ap";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }