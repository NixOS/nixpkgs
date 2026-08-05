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
  version = "20250512.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    tag = finalAttrs.version;
    hash = "sha256-NMdCALDFGGNNGyN17nwpRYBh/hoQoU7YMk66YDJndxQ=";
  };

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
      package = finalAttrs.finalPackage;
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
      "absl_log_internal_check_op"
      "absl_absl_check"
      "absl_strerror"
      "absl_common_policy_traits"
      "absl_graphcycles_internal"
      "absl_raw_hash_set"
      "absl_random_internal_entropy_pool"
      "absl_time_zone"
      "absl_prefetch"
      "absl_compressed_tuple"
      "absl_nullability"
      "absl_vlog_is_on"
      "absl_utf8_for_code_point"
      "absl_base_internal"
      "absl_bad_variant_access"
      "absl_flags_parse"
      "absl_exponential_biased"
      "absl_log_internal_nullstream"
      "absl_log_internal_structured_proto"
      "absl_log_internal_check_impl"
      "absl_tracing_internal"
      "absl_random_bit_gen_ref"
      "absl_meta"
      "absl_random_distributions"
      "absl_numeric"
      "absl_flat_hash_set"
      "absl_random_internal_randen_hwaes_impl"
      "absl_malloc_internal"
      "absl_layout"
      "absl_type_traits"
      "absl_random_internal_mock_helpers"
      "absl_log_streamer"
      "absl_function_ref"
      "absl_log"
      "absl_dynamic_annotations"
      "absl_non_temporal_memcpy"
      "absl_random_internal_randen"
      "absl_stacktrace"
      "absl_log_internal_globals"
      "absl_log_internal_strip"
      "absl_atomic_hook"
      "absl_flags_usage_internal"
      "absl_log_internal_voidify"
      "absl_synchronization"
      "absl_debugging_internal"
      "absl_bind_front"
      "absl_crc_internal"
      "absl_random_internal_platform"
      "absl_flags_path_util"
      "absl_hash_testing"
      "absl_flags_commandlineflag_internal"
      "absl_hashtable_debug"
      "absl_hashtablez_sampler"
      "absl_random_internal_randen_engine"
      "absl_log_globals"
      "absl_optional"
      "absl_crc_cpu_detect"
      "absl_demangle_internal"
      "absl_node_hash_map"
      "absl_core_headers"
      "absl_statusor"
      "absl_str_format_internal"
      "absl_crc32c"
      "absl_cordz_update_scope"
      "absl_cordz_handle"
      "absl_log_internal_nullguard"
      "absl_numeric_representation"
      "absl_log_internal_log_impl"
      "absl_raw_hash_set_resize_impl"
      "absl_random_internal_distribution_test_util"
      "absl_kernel_timeout_internal"
      "absl_random_internal_uniform_helper"
      "absl_random_seed_sequences"
      "absl_cordz_info"
      "absl_spy_hash_state"
      "absl_vlog_config_internal"
      "absl_flags_program_name"
      "absl_hashtable_debug_hooks"
      "absl_crc_cord_state"
      "absl_decode_rust_punycode"
      "absl_debugging"
      "absl_overload"
      "absl_config"
      "absl_random_internal_fast_uniform_bits"
      "absl_raw_hash_map"
      "absl_random_internal_randen_hwaes"
      "absl_bad_any_cast"
      "absl_variant"
      "absl_has_ostream_operator"
      "absl_span"
      "absl_btree"
      "absl_random_internal_distribution_caller"
      "absl_failure_signal_handler"
      "absl_any"
      "absl_poison"
      "absl_str_format"
      "absl_cord"
      "absl_random_internal_wide_multiply"
      "absl_random_internal_pcg_engine"
      "absl_flags_internal"
      "absl_check"
      "absl_random_internal_seed_material"
      "absl_log_flags"
      "absl_no_destructor"
      "absl_low_level_hash"
      "absl_hashtable_control_bytes"
      "absl_periodic_sampler"
      "absl_log_internal_format"
      "absl_log_initialize"
      "absl_random_internal_generate_real"
      "absl_raw_logging_internal"
      "absl_inlined_vector"
      "absl_log_internal_log_sink_set"
      "absl_log_internal_flags"
      "absl_flat_hash_map"
      "absl_scoped_mock_log"
      "absl_cordz_functions"
      "absl_random_mocking_bit_gen"
      "absl_fast_type_id"
      "absl_sample_recorder"
      "absl_log_internal_message"
      "absl_bits"
      "absl_random_seed_gen_exception"
      "absl_log_sink_registry"
      "absl_flags_marshalling"
      "absl_leak_check"
      "absl_examine_stack"
      "absl_status_matchers"
      "absl_flags_commandlineflag"
      "absl_absl_vlog_is_on"
      "absl_any_invocable"
      "absl_cleanup_internal"
      "absl_log_severity"
      "absl_random_internal_salted_seed_seq"
      "absl_flags_config"
      "absl_log_structured"
      "absl_die_if_null"
      "absl_fixed_array"
      "absl_cord_internal"
      "absl_endian"
      "absl_strings_internal"
      "absl_symbolize"
      "absl_log_internal_config"
      "absl_absl_log"
      "absl_memory"
      "absl_container_common"
      "absl_compare"
      "absl_civil_time"
      "absl_int128"
      "absl_log_internal_append_truncated"
      "absl_cordz_statistics"
      "absl_log_internal_fnmatch"
      "absl_flags"
      "absl_non_temporal_arm_intrinsics"
      "absl_random_internal_traits"
      "absl_base"
      "absl_algorithm_container"
      "absl_hash"
      "absl_log_internal_conditions"
      "absl_time"
      "absl_node_slot_policy"
      "absl_errno_saver"
      "absl_random_internal_randen_slow"
      "absl_charset"
      "absl_bounded_utf8_length_sequence"
      "absl_city"
      "absl_bad_optional_access"
      "absl_random_internal_nonsecure_base"
      "absl_flags_usage"
      "absl_utility"
      "absl_iterator_traits_internal"
      "absl_spinlock_wait"
      "absl_pretty_function"
      "absl_algorithm"
      "absl_log_sink"
      "absl_status"
      "absl_demangle_rust"
      "absl_node_hash_set"
      "absl_hash_policy_traits"
      "absl_flags_private_handle_accessor"
      "absl_cord_test_helpers"
      "absl_strings"
      "absl_log_internal_proto"
      "absl_inlined_vector_internal"
      "absl_iterator_traits_test_helper_internal"
      "absl_random_random"
      "absl_flags_reflection"
      "absl_scoped_set_env"
      "absl_throw_delegate"
      "absl_hash_function_defaults"
      "absl_weakly_mixed_integer"
      "absl_cleanup"
      "absl_random_internal_iostream_state_saver"
      "absl_cordz_sample_token"
      "absl_cordz_update_tracker"
      "absl_string_view"
      "absl_hash_container_defaults"
      "absl_random_internal_fastmath"
      "absl_log_internal_structured"
      "absl_container_memory"
      "absl_log_entry"
    ];
  };
})
