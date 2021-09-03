{ callPackage }:
  {
    caml = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "caml";
        ename = "caml";
        version = "4.7.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/caml-4.7.1.tar";
          sha256 = "1bv2fscy7zg7r1hyg4rpvh3991vmhy4zid7bv1qbhxa95m9c49j3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/caml.html";
          license = lib.licenses.free;
        };
      }) {};
    markdown-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "markdown-mode";
        ename = "markdown-mode";
        version = "2.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/markdown-mode-2.4.tar";
          sha256 = "002nvc2p7jzznr743znbml3vj8a3kvdd89rlbi28f5ha14g2567z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/markdown-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    org-contrib = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-contrib";
        ename = "org-contrib";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-contrib-0.1.tar";
          sha256 = "07hzywvgj11wd21dw4lbkvqv32da03407f9qynlzgg1qa7wknm2k";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
    request = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "request";
        ename = "request";
        version = "0.3.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/request-0.3.3.tar";
          sha256 = "168yy902bcjfdaahsbzhzb4wgqbw1mq1lfwdjh66fpzqs75c5q00";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/request.html";
          license = lib.licenses.free;
        };
      }) {};
    sly = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sly";
        ename = "sly";
        version = "1.0.43";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sly-1.0.43.tar";
          sha256 = "0qgji539qwk7lv9g1k11w0i2nn7n7nk456gwa0bh556mcqz2ndr8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sly.html";
          license = lib.licenses.free;
        };
      }) {};
    tuareg = callPackage ({ caml, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tuareg";
        ename = "tuareg";
        version = "2.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/tuareg-2.3.0.tar";
          sha256 = "0a24q64yk4bbgsvm56j1y68zs9yi25qyl83xydx3ff75sk27f1yb";
        };
        packageRequires = [ caml emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tuareg.html";
          license = lib.licenses.free;
        };
      }) {};
  }
