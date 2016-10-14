{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161003";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161003.tar";
          sha256 = "1q59s9ir9x8ig4nfx6vbq3dj3ah01sjwvqax2x2dqxn2mk2igr4x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161003";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161003.tar";
          sha256 = "0phi7jdkv7m4y7q7ilkz0dfw9g11d52dd34pv41dvawf032wvwn7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }