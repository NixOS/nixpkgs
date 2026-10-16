{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "pgtui";
  version = "0.14.0";

  src = fetchFromCodeberg {
    owner = "kdwarn";
    repo = "pgtui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sIrB1eaKJr0CJ42KPtIUhBQgPf2VoZJk5uQUS/gHBjE=";
  };

  cargoHash = "sha256-QxG+OtFZr5SIsnzCyuMf03J2CKgeGDHHcvERx6O+DJk=";

  checkFlags = [
    "--skip=db_tests::tests::test_connection"
    "--skip=editor::tests::insert_successful_in_mixed_case_table"
    "--skip=editor::tests::insert_successful_with_pk"
    "--skip=editor::tests::update_errs_when_no_primary_key"
    "--skip=editor::tests::update_success_in_mixed_case_table"
    "--skip=editor::tests::update_success_when_primary_key_is_identity"
    "--skip=editor::tests::update_success_with_bigint_pk"
    "--skip=editor::tests::update_success_with_bpchar_pk"
    "--skip=editor::tests::update_success_with_char_pk"
    "--skip=editor::tests::update_success_with_char_var_pk"
    "--skip=editor::tests::update_success_with_citext_pk"
    "--skip=editor::tests::update_success_with_date_pk"
    "--skip=editor::tests::update_success_with_dbl_pk"
    "--skip=editor::tests::update_success_with_dt_no_tz_pk"
    "--skip=editor::tests::update_success_with_dt_with_tz_pk"
    "--skip=editor::tests::update_success_with_f32real_pk"
    "--skip=editor::tests::update_success_with_int_pk"
    "--skip=editor::tests::update_success_with_numeric_pk"
    "--skip=editor::tests::update_success_with_smallint_pk"
    "--skip=editor::tests::update_success_with_text_pk"
    "--skip=editor::tests::update_success_with_time_no_tz_pk"
    "--skip=fields::tests::collect_field_errs_when_relation_not_handled_type"
    "--skip=fields::tests::collect_field_metadata_errs_when_relation_not_handled_type"
    "--skip=fields::tests::field_collect"
    "--skip=fields::tests::fieldmeta_collect"
    "--skip=fields::tests::verify_big_decimal_types"
    "--skip=fields::tests::verify_char_types"
    "--skip=fields::tests::verify_date_types"
    "--skip=fields::tests::verify_datetime_types"
    "--skip=fields::tests::verify_datetime_values"
    "--skip=fields::tests::verify_float32_types"
    "--skip=fields::tests::verify_float64_types"
    "--skip=fields::tests::verify_integer_types"
    "--skip=fields::tests::verify_time_no_tz_types"
    "--skip=fields::tests::verify_time_no_tz_values"
    "--skip=fields::tests::verify_time_with_tz_types"
    "--skip=relations::tests::data_definition_correct"
    "--skip=relations::tests::multi_col_primary_key_correct"
    "--skip=relations::tests::single_col_int_primary_key_correct"
    "--skip=relations::tests::single_col_text_primary_key_correct"
  ];

  meta = {
    description = "A Postgres TUI client that utilizes your terminal text editor for inserts & updates";
    mainProgram = "pgtui";
    homepage = "https://kdwarn.net/pgtui";
    changelog = "https://codeberg.org/kdwarn/pgtui/src/tag//v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
