{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171113";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171113.tar";
          sha256 = "0lip21hxq912ya2cgfls3c4clks9knsf2cma9dabbdkiz9jmw1xq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171113";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171113.tar";
          sha256 = "1yy24rgdfvs99rj0zi74djb7l4wmj3w1i6m6j8z6xkqnhixwg5w7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }