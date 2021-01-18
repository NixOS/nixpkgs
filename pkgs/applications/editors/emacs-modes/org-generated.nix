{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210111";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210111.tar";
          sha256 = "1hn3i583h3idmiv1plbp0p6qi3myl317vl43qyxjks2nvqfj5313";
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
        version = "20210111";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210111.tar";
          sha256 = "1qw44y4v4vg0vhz1i55x4fjiaxfaqcch0mqm98sc5f31fw3r4zga";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
