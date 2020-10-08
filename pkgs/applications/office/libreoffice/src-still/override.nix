{ stdenv, kdeIntegration, fetchpatch, ... }:
attrs:
{
  patches = attrs.patches or [ ] ++ [
    (fetchpatch {
      url = "https://git.pld-linux.org/gitweb.cgi?p=packages/libreoffice.git;a=blob_plain;f=poppler-0.86.patch;h=76b8356d5f22ef537a83b0f9b0debab591f152fe;hb=a2737a61353e305a9ee69640fb20d4582c218008";
      name = "poppler-0.86.patch";
      sha256 = "0q6k4l8imgp8ailcv0qx5l83afyw44hah24fi7gjrm9xgv5sbb8j";
    })
  ];
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/extras/inc/swmodeltestbase.hxx'
  '';
  configureFlags = stdenv.lib.remove "--without-system-qrcodegen"
  (attrs.configureFlags ++ [
    (stdenv.lib.enableFeature kdeIntegration "kde5")
  ]);
  meta = attrs.meta // { description = "Comprehensive, professional-quality productivity suite (Still/Stable release)"; };
}
