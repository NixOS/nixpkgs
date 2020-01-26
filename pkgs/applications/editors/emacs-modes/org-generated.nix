{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20191203";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20191203.tar";
          sha256 = "1fcgiswjnqmfzx3xkmlqyyhc4a8ms07vdsv7nkizgxqdh9hwfm2q";
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
        version = "20191203";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20191203.tar";
          sha256 = "1kvw95492acb7gqn8gxbp1vg4fyw80w43yvflxnfxdf6jnnw2wah";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
