{ lib, kdeIntegration, commonsLogging, ... }:
attrs:
{
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/inc/swmodeltestbase.hxx'
  '';
  configureFlags = attrs.configureFlags ++ [
    (lib.enableFeature kdeIntegration "kf5")
    "--with-commons-logging-jar=${commonsLogging}/share/java/commons-logging-1.2.jar"
    "--without-system-qrcodegen"
  ];
  patches = [ ../xdg-open-brief.patch ]; # drop this when switching to 7.2
}
