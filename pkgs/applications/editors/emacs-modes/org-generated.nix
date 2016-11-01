{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161031";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161031.tar";
          sha256 = "1nabn8kj50bxvm3b429j73xipq557kx5j4nr7s5bwxs85i89133q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161031";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161031.tar";
          sha256 = "1j0mwqmdyslvdfhd3x9c9li8s41wsaxk81qzfizdwxl9csdf9ki4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }