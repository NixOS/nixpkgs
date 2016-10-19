{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161017";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161017.tar";
          sha256 = "0hpvi68pzja6qna4x6bvj7hzfnfkgmmix7ramvr1q3m2nqxv2pvx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161017";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161017.tar";
          sha256 = "1qahvhkfgf5wh96j1v1c03yspjfqacyinix97is93c3nm94279f4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }