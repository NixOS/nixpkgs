{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180108";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180108.tar";
          sha256 = "02rs7zi3dzps0mlyfbgiywd2smnlw0pk8ps1nqk0d5hx3n6d15yv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180108";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180108.tar";
          sha256 = "10mhiqsrxxmhsy8dl88r456shx6ajm4w19pz259b960551r596iz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }