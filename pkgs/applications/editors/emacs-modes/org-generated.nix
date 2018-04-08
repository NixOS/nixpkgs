{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180402";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180402.tar";
          sha256 = "0gb8hh26jzjqy262ll8jl3ym0cpw6s17id2gizv5qvw18knxs751";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180402";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180402.tar";
          sha256 = "09q5nr0ka7z719mi626wj5d51bcvdb08gk4zf94dzpks0gsqiikr";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }