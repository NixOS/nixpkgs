{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200921";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200921.tar";
          sha256 = "0qwa375j11d2rx6z18sr6s4qja96k78rv9r2y04ksn103gr9dd4l";
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
        version = "20200921";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200921.tar";
          sha256 = "1chxm7w8ls2qmrzvv80m3pmi5x5gybppfzpvgxlankz5rj34vgd3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }