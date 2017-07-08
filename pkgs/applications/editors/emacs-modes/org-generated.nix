{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170703";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170703.tar";
          sha256 = "0l590ygknlbz3r0w9zzljwqn8vasz5w82wsivi9bi60lf0d0hx58";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170703";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170703.tar";
          sha256 = "0l7hsz6rbq1zw6wdlm3ryxb60md44rvx0waii98hww89zpdi0gmw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }