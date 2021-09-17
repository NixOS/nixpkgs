{ lib, kdeIntegration, ... }:
attrs:
{
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/inc/swmodeltestbase.hxx'
  '';
  configureFlags = attrs.configureFlags ++ [
    (lib.enableFeature kdeIntegration "kf5")
  ];
  patches = [ ../xdg-open-brief.patch ]; # drop this when switching fresh to 7.2.0
}
