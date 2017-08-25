{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170821";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170821.tar";
          sha256 = "0pfqm8r1hgk1mf57rwp1h46gc5dwsyfkgnpw01a8y5w35dcsvz4j";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170821";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170821.tar";
          sha256 = "0m5zym1b4kr7q3ps41rhz92krbjmk9m220hc0rdym95gyjfzw62i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }