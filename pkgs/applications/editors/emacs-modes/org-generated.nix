{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171225";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171225.tar";
          sha256 = "1wp1mbp0b8vygrlx0bb79d9zb91kca13nlhrxh59h9w496jj30dy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171225";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171225.tar";
          sha256 = "10d44sqm9sh8gjy7xlnpqhyq35yxdijjm2322khc5bylvq60ianc";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }