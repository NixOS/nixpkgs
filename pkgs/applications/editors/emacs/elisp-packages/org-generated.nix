{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210607";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210607.tar";
          sha256 = "178z9bnzcdaymnwxf0kkw1yzlzkj5dmdjjwdklc9qb9iv6rckfji";
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
        version = "20210607";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210607.tar";
          sha256 = "03liivgfcmp0lh6p57bh2gyn85n3sc4p91y374kq8kzc7fzrgzyr";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
