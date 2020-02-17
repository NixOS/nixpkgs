{ stdenv, kdeIntegration, ... }:
attrs:
{
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/extras/inc/swmodeltestbase.hxx'
  '';
  configureFlags = stdenv.lib.remove "--without-system-qrcodegen"
  (attrs.configureFlags ++ [
    (stdenv.lib.enableFeature kdeIntegration "kde5")
  ]);
  meta = attrs.meta // { description = "Comprehensive, professional-quality productivity suite (Still/Stable release)"; };
}
