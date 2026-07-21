{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  static ? stdenv.hostPlatform.isStatic,
  cxxStandard ? null,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abseil-cpp";
  version = "20250814.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    tag = finalAttrs.version;
    hash = "sha256-PCospVD/hnbT/87tRtvick+RIuwAv7DDPGnLG3ZMb3g=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "ABSL_BUILD_TEST_HELPERS" true)
    (lib.cmakeBool "ABSL_USE_EXTERNAL_GOOGLETEST" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
  ]
  ++ lib.optionals (cxxStandard != null) [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxxStandard)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [ gtest ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage.dev;
    };
  };

  meta = {
    description = "Open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    changelog = "https://github.com/abseil/abseil-cpp/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.GaetanLepage ];
    pkgConfigModules = [
      "absl_base"
      "absl_city"
      "absl_civil_time"
      "absl_cord_internal"
      "absl_cord"
      "absl_cordz_functions"
      "absl_cordz_handle"
      "absl_cordz_info"
      "absl_cordz_sample_token"
      "absl_crc_cord_state"
      "absl_crc_cpu_detect"
      "absl_crc_internal"
      "absl_crc32c"
      "absl_debugging_internal"
      "absl_decode_rust_punycode"
      "absl_demangle_internal"
      "absl_demangle_rust"
      "absl_die_if_null"
      "absl_examine_stack"
      "absl_exponential_biased"
      "absl_failure_signal_handler"
      "absl_flags_commandlineflag_internal"
      "absl_flags_commandlineflag"
      "absl_flags_config"
      "absl_flags_internal"
      "absl_flags_marshalling"
      "absl_flags_parse"
      "absl_flags_private_handle_accessor"
      "absl_flags_program_name"
      "absl_flags_reflection"
      "absl_flags_usage_internal"
      "absl_flags_usage"
      "absl_graphcycles_internal"
      "absl_hash"
      "absl_hashtable_profiler"
      "absl_hashtablez_sampler"
      "absl_int128"
      "absl_kernel_timeout_internal"
      "absl_leak_check"
      "absl_log_entry"
      "absl_log_flags"
      "absl_log_globals"
      "absl_log_initialize"
      "absl_log_internal_check_op"
      "absl_log_internal_conditions"
      "absl_log_internal_fnmatch"
      "absl_log_internal_format"
      "absl_log_internal_globals"
      "absl_log_internal_log_sink_set"
      "absl_log_internal_message"
      "absl_log_internal_nullguard"
      "absl_log_internal_proto"
      "absl_log_internal_structured_proto"
      "absl_log_severity"
      "absl_log_sink"
      "absl_malloc_internal"
      "absl_periodic_sampler"
      "absl_poison"
      "absl_profile_builder"
      "absl_random_distributions"
      "absl_random_internal_distribution_test_util"
      "absl_random_internal_entropy_pool"
      "absl_random_internal_platform"
      "absl_random_internal_randen_hwaes_impl"
      "absl_random_internal_randen_hwaes"
      "absl_random_internal_randen_slow"
      "absl_random_internal_randen"
      "absl_random_internal_seed_material"
      "absl_random_seed_gen_exception"
      "absl_random_seed_sequences"
      "absl_raw_hash_set"
      "absl_raw_logging_internal"
      "absl_scoped_mock_log"
      "absl_scoped_set_env"
      "absl_spinlock_wait"
      "absl_stacktrace"
      "absl_status_matchers"
      "absl_status"
      "absl_statusor"
      "absl_str_format_internal"
      "absl_strerror"
      "absl_string_view"
      "absl_strings_internal"
      "absl_strings"
      "absl_symbolize"
      "absl_synchronization"
      "absl_throw_delegate"
      "absl_time_zone"
      "absl_time"
      "absl_tracing_internal"
      "absl_utf8_for_code_point"
      "absl_vlog_config_internal"
    ];
  };
})
