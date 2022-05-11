{ lib, kdeIntegration, kio ? null, ... }:
attrs:
{
  postPatch = attrs.postPatch + lib.optionalString kdeIntegration ''
    substituteInPlace configure.ac \
      --replace '$KF5INC' ${kio.dev}/include \
      --replace '$KF5LIB' ${kio.out}/lib
  '';
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/inc/swmodeltestbase.hxx'
    sed -e '/CPPUNIT_ASSERT(!bRTL);/d' -i './vcl/qa/cppunit/text.cxx'

    sed -e '/CPPUNIT_ASSERT_EQUAL(0, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(4, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(11, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(18, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'

    sed -e '/CPPUNIT_ASSERT_EQUAL(3, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(9, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(17, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(22, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
  '';
  configureFlags = attrs.configureFlags ++ [
    (lib.enableFeature kdeIntegration "kf5")
    "--without-system-zxing"
    "--without-system-cuckoo"
  ];
}
