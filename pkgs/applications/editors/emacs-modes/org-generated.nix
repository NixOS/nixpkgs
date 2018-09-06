{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20180723";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20180723.tar";
          sha256 = "1mcgnba16lpyh55zjx4rcbmpygcmdnjjzvgv1rx0c3kz1h5fgzf8";
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
        version = "20180723";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20180723.tar";
          sha256 = "1l34bagkm8mcyv5diprpbd4yjijkdvx1l54qpvi8bmvxjnzsm7mk";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }