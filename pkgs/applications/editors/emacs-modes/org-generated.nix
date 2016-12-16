{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161214";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161214.tar";
          sha256 = "1x3wvagx7437xr4lawxr24kivb661997bncq2w9iz3fkg9rrr73m";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161214";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161214.tar";
          sha256 = "1rc3p1cys15i9vnll946w5hlckmmbgkw22yw98mna9cwqdpc387c";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }