{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161024";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161024.tar";
          sha256 = "0yph2wiwl426wn1vgbwxgnh8lr6x40swbpzzl87vfzfh5wjx4l1h";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161024";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161024.tar";
          sha256 = "1pr4mnf8mrxnlnn61y3w1jkwf1d7wlf9v8j65vvs1c26rbnzms85";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }