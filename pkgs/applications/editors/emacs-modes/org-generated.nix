{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        version = "20180716";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20180716.tar";
          sha256 = "0gr57nfdncnxrxxzw87ni5i6zjh1mdxl9h8pw96msh1c47xhpk2d";
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
        version = "20180716";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20180716.tar";
          sha256 = "0j4r3bcy96kcaab7cv2a5qd0mv8ddkr1qlihijk79l9nhsh2y4hm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }