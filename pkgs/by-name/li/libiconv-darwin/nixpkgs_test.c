#include <atf-c.h>
#include <iconv.h>
#include <stdint.h>

// The following tests were failing in libarchive due to libiconv issues.
//   218: test_read_format_cab_filename (4 failures)
//   415: test_read_format_zip_filename_CP932_eucJP (4 failures)
//   426: test_read_format_zip_filename_CP932_CP932 (2 failures)

ATF_TC(test_cp932_eucjp);
ATF_TC_HEAD(test_cp932_eucjp, tc)
{
    atf_tc_set_md_var(tc, "descr", "regression test for CP932 to EUC-JP conversion");
}
ATF_TC_BODY(test_cp932_eucjp, tc)
{
    char expected[] = "\xc9\xbd\xa4\xc0\xa4\xe8\x5c\xb4\xc1\xbb\xfa\x2e\x74\x78\x74";
    size_t expected_length = sizeof(expected) - 1;

    char input[] = "\x95\x5c\x82\xbe\x82\xe6\x5c\x8a\xbf\x8e\x9a\x2e\x74\x78\x74";
    size_t input_length = sizeof(input) - 1;

    size_t output_available = sizeof(expected) - 1 ;
    char output[sizeof(expected)] = { 0 };

    iconv_t cd = iconv_open("eucJP", "CP932");
    ATF_REQUIRE((size_t)cd != -1);

    char* input_buf = input;
    char* output_buf = output;

    size_t res = iconv(cd, &input_buf, &input_length, &output_buf, &output_available);
    iconv_close(cd);

    ATF_CHECK(res != -1);

    size_t output_length = sizeof(output) - output_available - 1;

    ATF_CHECK_INTEQ(expected_length, output_length);
    ATF_CHECK_STREQ(expected, output);
}

ATF_TC(test_cp932_cp932);
ATF_TC_HEAD(test_cp932_cp932, tc)
{
    atf_tc_set_md_var(tc, "descr", "regression test for CP932 to CP932 conversion");
}
ATF_TC_BODY(test_cp932_cp932, tc)
{
    char expected[] = "\x95\x5c\x82\xbe\x82\xe6\x5c\x8a\xbf\x8e\x9a\x2e\x74\x78\x74";
    size_t expected_length = sizeof(expected) - 1;

    char input[] = "\x95\x5c\x82\xbe\x82\xe6\x5c\x8a\xbf\x8e\x9a\x2e\x74\x78\x74";
    size_t input_length = sizeof(input) - 1;

    size_t output_available = sizeof(expected) - 1 ;
    char output[sizeof(expected)] = { 0 };

    iconv_t cd = iconv_open("CP932", "CP932");
    ATF_REQUIRE((size_t)cd != -1);

    char* input_buf = input;
    char* output_buf = output;

    size_t res = iconv(cd, &input_buf, &input_length, &output_buf, &output_available);
    iconv_close(cd);

    ATF_CHECK(res != -1);

    size_t output_length = sizeof(output) - output_available - 1;

    ATF_CHECK_INTEQ(expected_length, output_length);
    ATF_CHECK_STREQ(expected, output);
}

ATF_TP_ADD_TCS(tp)
{
    ATF_TP_ADD_TC(tp, test_cp932_eucjp);
    ATF_TP_ADD_TC(tp, test_cp932_cp932);

    return atf_no_error();
}
