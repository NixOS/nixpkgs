{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210503";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210503.tar";
          sha256 = "0j9p834c67qzxbxz8s1n8l5blylrpb3jh9wywphlb6jgbgl0mw09";
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
        version = "20210503";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210503.tar";
          sha256 = "0k0wmnx2g919h3s9ynv1cvdlyxvydglslamlwph4xng4kzcr5lrk";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
