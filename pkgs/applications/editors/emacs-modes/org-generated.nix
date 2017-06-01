{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170515";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170515.tar";
          sha256 = "04kpi7q1q4r9w4km941cy70q3k9azspw1wdr71if4f8am6frj3d4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170515";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170515.tar";
          sha256 = "0jdcxir8wvmdxi0rxnljbhy31yh83n4p0l8jp85fxf5sx0kcc32p";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }