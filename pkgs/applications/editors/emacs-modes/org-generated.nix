{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170210";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170210.tar";
          sha256 = "1v8adjz3rv429is8m7xx2v8hvc20dxl4hcdhdf2vhcx44bgbvyjb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170210";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170210.tar";
          sha256 = "1h0lwf1sw7n1df865ip5mp0pdmdi2md6hz6fq53r4zhali041ifx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }