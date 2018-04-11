{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180409";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180409.tar";
          sha256 = "0vnyh30pqnpfwmkm2gmidw00mgrwsbvxmjv40yhrv7144392iisl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180409";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180409.tar";
          sha256 = "18zb6vx06gwxgy85a5fmvjwb8fqb4cn74n1mfk64p3acnsnwikkg";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }