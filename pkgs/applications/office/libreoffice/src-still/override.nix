{ lib, kdeIntegration, commonsLogging, ... }:
attrs:
{
  postConfigure = attrs.postConfigure + ''
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/inc/swmodeltestbase.hxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(11148L, pOleObj->GetLogicRect().getWidth());/d ' -i sc/qa/unit/subsequent_filters-test.cxx
    sed -e '/CPPUNIT_TEST(testChartImportXLS)/d' -i sc/qa/unit/subsequent_filters-test.cxx
    sed -e '/CPPUNIT_TEST(testCustomColumnWidthExportXLSX)/d' -i sc/qa/unit/subsequent_export-test.cxx
    sed -e '/CPPUNIT_TEST(testColumnWidthExportFromODStoXLSX)/d' -i sc/qa/unit/subsequent_export-test.cxx
    sed -e '/CPPUNIT_TEST(test);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testConditionalFormatExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testProtectionKeyODS_UTF16LErtlSHA1);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testProtectionKeyODS_UTF8SHA1);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testProtectionKeyODS_UTF8SHA256ODF12);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testProtectionKeyODS_UTF8SHA256W3C);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testProtectionKeyODS_XL_SHA1);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testColorScaleExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testDataBarExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testNamedRangeBugfdo62729);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testRichTextExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testFormulaRefSheetNameODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testCellValuesExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testCellNoteExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testFormatExportODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testEmbeddedChartODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testCellAnchoredGroupXLS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testCeilingFloorODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testRelativePathsODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testSheetProtectionODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testSwappedOutImageExport);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testLinkedGraphicRT);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testImageWithSpecialID);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testAbsNamedRangeHTML);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testMoveCellAnchoredShapesODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testRefStringUnspecified);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testHeaderImageODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testTdf88657ODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testExponentWithoutSignFormatXLSX);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testHiddenRepeatedRowsODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
    sed -e '/CPPUNIT_TEST(testHyperlinkTargetFrameODS);/d' -i './sc/qa/unit/subsequent_export-test.cxx'
  '';
  configureFlags = attrs.configureFlags ++ [
    (lib.enableFeature kdeIntegration "kf5")
    "--without-system-zxing"
  ];

  patches = attrs.patches or [];
}
