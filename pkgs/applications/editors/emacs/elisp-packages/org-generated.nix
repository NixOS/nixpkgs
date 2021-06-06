{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210519";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210519.tar";
          sha256 = "14vchfg69wai1yxv1fzvjk185gnfr7d9qrdijf0qmbbr5znci8rf";
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
        version = "20210519";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210519.tar";
          sha256 = "0g765fsc7ssn779xnhjzrxy1sz5b019h7dk1q26yk2w6i540ybfl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
