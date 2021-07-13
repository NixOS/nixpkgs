{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210628";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210628.tar";
          sha256 = "1sn2yyynndk8qf43ss8bayll33r4ina8xfx4ywzcs3m1lm6xy1zl";
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
        version = "20210628";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210628.tar";
          sha256 = "0r4kxp1hbhkwvi7939fglng8db4h4n7vigy8pd2gia3a02xcw8l5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
