{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210906";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210906.tar";
          sha256 = "04aqniwix4w0iap38dsdskndknhw9k6apkmkrc79yfs3c4jcsszq";
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
        version = "20210906";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210906.tar";
          sha256 = "1v0yy92x8shwp36qfyzmvk8ayz9amkdis967gqacq5jxcyq7mhbn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
