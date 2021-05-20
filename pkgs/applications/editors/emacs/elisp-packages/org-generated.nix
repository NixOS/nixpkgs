{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210510";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210510.tar";
          sha256 = "015c68pk52vksar7kpyb0nkcyjihlczmpq4h5vdv8xayas2qlzc7";
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
        version = "20210510";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210510.tar";
          sha256 = "0pdwjnpcsk75jv4qs8n4xia6vspwn6dndbdx9z7kq5vqz7w4ykmw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
