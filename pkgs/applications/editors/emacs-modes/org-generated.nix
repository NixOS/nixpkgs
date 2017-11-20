{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171120";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171120.tar";
          sha256 = "1xpfs0bz5lb4jmzd0kk5mgl2yfk0hb6hk788x9rn7i1n1dnz4mdy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171120";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171120.tar";
          sha256 = "1ivrdxfvxiqj3ydc9d9vmh8wcb4ydavrn9mprx74kg4g084v9y26";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }