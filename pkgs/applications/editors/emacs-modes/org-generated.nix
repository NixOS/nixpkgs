{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20160912";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20160912.tar";
          sha256 = "1xawj0pdvqrgzlixxgbfa01gzajfaz47anr5m4aw035rhc6s02r7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20160912";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20160912.tar";
          sha256 = "15id0gz60hqbhr183vnz4winpisa2kwrh47zqz37a5yx5b8fc84r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }