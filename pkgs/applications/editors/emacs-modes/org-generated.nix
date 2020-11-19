{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200817";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200817.tar";
          sha256 = "159hch9zls3apxq11c5rjpmci1avyl7q3cgsrqxwgnzy8c61104d";
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
        version = "20200817";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200817.tar";
          sha256 = "0n3fhcxjsk2w78p7djna4nlppa7ypjxzpq3r5dmzc8jpl71mipba";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }