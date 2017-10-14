{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171009";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171009.tar";
          sha256 = "1v8y4gmfrnzsdy9mspqzn157da7lb7z2wvp95r1iywf64325gv5s";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171009";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171009.tar";
          sha256 = "0iv1f7hbqh46mymk097x69q00pqpbkcyzjfd9a9slf5xkw1g1lk1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }