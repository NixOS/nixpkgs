{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20180910";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20180910.tar";
          sha256 = "1j4n0a07bxjbdzx3dipxgi0h5r0yimwylp9cnzfm6m7nc7kas2sq";
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
        version = "20180910";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20180910.tar";
          sha256 = "17inl07kjdjamlqbyxbp42kx1nkbhbhz7lzqfvkhk6s7z16qvksq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }