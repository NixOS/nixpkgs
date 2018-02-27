{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180226";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180226.tar";
          sha256 = "0jqvry6gah1bwnryha4asynj13jyds3qim0xcy7s01rxk99m2ziy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180226";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180226.tar";
          sha256 = "034wp70hcqnpidji5k1k80mj35iyyy098nbvc2sl7i2aca4m03zc";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }