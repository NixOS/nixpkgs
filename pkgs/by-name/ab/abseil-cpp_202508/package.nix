{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  testers,
  validatePkgConfig,
  static ? stdenv.hostPlatform.isStatic,
  cxxStandard ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abseil-cpp";
  version = "20250814.1";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    tag = finalAttrs.version;
    hash = "sha256-SCQDORhmJmTb0CYm15zjEa7dkwc+lpW2s1d4DsMRovI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    cat ->> CMakeLists.txt <<'EOF'
    # Configure and install pkg-config file
    configure_file(
      "''${PROJECT_SOURCE_DIR}/absl.pc.in"
      "''${PROJECT_BINARY_DIR}/absl.pc"
      @ONLY
    )
    install(
      FILES "''${PROJECT_BINARY_DIR}/absl.pc"
      DESTINATION "''${CMAKE_INSTALL_LIBDIR}/pkgconfig"
      COMPONENT nbytes_development
    )
    EOF
    cat -> absl.pc.in <<'EOF'
    prefix=@CMAKE_INSTALL_PREFIX@
    exec_prefix=''${prefix}
    libdir=@CMAKE_INSTALL_FULL_LIBDIR@
    includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@
    Name: ${finalAttrs.pname}
    Description: ${finalAttrs.meta.description}
    Version: @PROJECT_VERSION@
    Libs: -L''${libdir} -labsl_base -labsl_city -labsl_civil_time -labsl_cord_internal -labsl_cord -labsl_cordz_functions -labsl_cordz_handle -labsl_cordz_info -labsl_cordz_sample_token -labsl_crc_cord_state -labsl_crc_cpu_detect -labsl_crc_internal -labsl_crc32c -labsl_debugging_internal -labsl_decode_rust_punycode -labsl_demangle_internal -labsl_demangle_rust -labsl_die_if_null -labsl_examine_stack -labsl_exponential_biased -labsl_failure_signal_handler -labsl_flags_commandlineflag_internal -labsl_flags_commandlineflag -labsl_flags_config -labsl_flags_internal -labsl_flags_marshalling -labsl_flags_parse -labsl_flags_private_handle_accessor -labsl_flags_program_name -labsl_flags_reflection -labsl_flags_usage_internal -labsl_flags_usage -labsl_graphcycles_internal -labsl_hash -labsl_hashtable_profiler -labsl_hashtablez_sampler -labsl_int128 -labsl_kernel_timeout_internal -labsl_leak_check -labsl_log_entry -labsl_log_flags -labsl_log_globals -labsl_log_initialize -labsl_log_internal_check_op -labsl_log_internal_conditions -labsl_log_internal_fnmatch -labsl_log_internal_format -labsl_log_internal_globals -labsl_log_internal_log_sink_set -labsl_log_internal_message -labsl_log_internal_nullguard -labsl_log_internal_proto -labsl_log_internal_structured_proto -labsl_log_severity -labsl_log_sink -labsl_malloc_internal -labsl_periodic_sampler -labsl_poison -labsl_profile_builder -labsl_random_distributions -labsl_random_internal_distribution_test_util -labsl_random_internal_entropy_pool -labsl_random_internal_platform -labsl_random_internal_randen_hwaes_impl -labsl_random_internal_randen_hwaes -labsl_random_internal_randen_slow -labsl_random_internal_randen -labsl_random_internal_seed_material -labsl_random_seed_gen_exception -labsl_random_seed_sequences -labsl_raw_hash_set -labsl_raw_logging_internal -labsl_scoped_mock_log -labsl_scoped_set_env -labsl_spinlock_wait -labsl_stacktrace -labsl_status_matchers -labsl_status -labsl_statusor -labsl_str_format_internal -labsl_strerror -labsl_string_view -labsl_strings_internal -labsl_strings -labsl_symbolize -labsl_synchronization -labsl_throw_delegate -labsl_time_zone -labsl_time -labsl_tracing_internal -labsl_utf8_for_code_point -labsl_vlog_config_internal
    Cflags: -I''${includedir}
    EOF
  '';

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
  };
})
