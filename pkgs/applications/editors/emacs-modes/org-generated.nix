{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171205";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171205.tar";
          sha256 = "0n8v5x50p8p52wwszzhf5y39ll2aaackvi64ldchnj06lqy3ni88";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171205";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171205.tar";
          sha256 = "1y61csa284gy8l0fj0mv67mkm4fsi4lz401987qp6a6z260df4n5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }