{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170124";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170124.tar";
          sha256 = "0zlqb31fkwv74wszfz914agnprnh6jlr60v9dw62y9jyivaxg99k";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170124";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170124.tar";
          sha256 = "1vgiw9xbh7zcr7gywb021h46idm0k69ifgkmwb9f9wb4snar4yq8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }