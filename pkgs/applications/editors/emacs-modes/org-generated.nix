{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20181230";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20181230.tar";
          sha256 = "1ydl6cikf4myrz59qvajbdxg1bvbpqjlkxn54qhrhh4755llcfkv";
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
        version = "20181230";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20181230.tar";
          sha256 = "0gibwcjlardjwq19bh0zzszv0dxxlml0rh5iikkcdynbgndk1aa1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }