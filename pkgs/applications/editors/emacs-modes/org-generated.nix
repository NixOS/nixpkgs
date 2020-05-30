{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200511";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200511.tar";
          sha256 = "147k6nmq00milw5knyhw01z481rcdl6s30vk4fkjidw508nkmg9c";
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
        version = "20200511";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200511.tar";
          sha256 = "1hsdp7n985404zdqj6gyfw1bxxbs0p3bf4fyizvgji21zxwnf63f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }