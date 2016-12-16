{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161118";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161118.tar";
          sha256 = "1lk2j93zcaamj2m2720nxsza7j35054kg72w35w9z1bbiqmv2haj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161118";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161118.tar";
          sha256 = "1la8qw18akqc4p7p0qi675xm3r149vwazzjc2gkik97p12ip83z7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }