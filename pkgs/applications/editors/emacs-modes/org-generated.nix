{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171016";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171016.tar";
          sha256 = "1v89wl8xlxavvv2kdd5vms0rwpqaw2x73q0162ybxmrzf4a5f5mw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171016";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171016.tar";
          sha256 = "0xy2xrndlhs4kyvh6mmv24dnh3fn5p63d2gaimnrypf1p8znwzh4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }