{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180115";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180115.tar";
          sha256 = "1zc75kxbx9bk1xag46s027a290fnva1id8vv92lz9i5nkqnrm430";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180115";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180115.tar";
          sha256 = "1gm6b0hpa4y83bxsbps39b1xvq99m1dh9nbvn9r4spw4rxhhfppy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }