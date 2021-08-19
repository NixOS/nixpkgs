{ lib, kdeIntegration, ... }:
attrs:
{
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/inc/swmodeltestbase.hxx'
  '';
  configureFlags = attrs.configureFlags ++ [
    (lib.enableFeature kdeIntegration "kf5")
  ];
  patches = [ ./xdg-open-brief.patch ];
  postPatch = attrs.postPatch + ''
    substituteInPlace shell/source/unix/exec/shellexec.cxx \
      --replace /usr/bin/xdg-open ${if kdeIntegration then "kde-open5" else "xdg-open"}
  '';
}
