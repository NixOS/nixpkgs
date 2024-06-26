{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libunwind,
}:

rustPlatform.buildRustPackage rec {
  pname = "bugstalker";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${version}";
    hash = "sha256-16bmvz6/t8H8Sx/32l+fp3QqP5lwi0o1Q9KqDHqF22U=";
  };

  cargoHash = "sha256-kp0GZ0cM57BMpH/8lhxevnBuJhUSH0rtxP4B/9fXYiU=";

  buildInputs = [ libunwind ];

  nativeBuildInputs = [ pkg-config ];

  # Tests which require access to example source code fail in the sandbox. I
  # haven't managed to figure out how to fix this.
  checkFlags = [
    "--skip=breakpoints::test_breakpoint_at_fn_with_monomorphization"
    "--skip=breakpoints::test_breakpoint_at_line_with_monomorphization"
    "--skip=breakpoints::test_brkpt_on_function"
    "--skip=breakpoints::test_brkpt_on_function_name_collision"
    "--skip=breakpoints::test_brkpt_on_line"
    "--skip=breakpoints::test_brkpt_on_line2"
    "--skip=breakpoints::test_brkpt_on_line_collision"
    "--skip=breakpoints::test_debugee_run"
    "--skip=breakpoints::test_deferred_breakpoint"
    "--skip=breakpoints::test_multiple_brkpt_on_addr"
    "--skip=breakpoints::test_set_breakpoint_idempotence"
    "--skip=io::test_backtrace"
    "--skip=io::test_read_register_write"
    "--skip=io::test_read_value_u64"
    "--skip=multithreaded::test_multithreaded_app_running"
    "--skip=multithreaded::test_multithreaded_backtrace"
    "--skip=multithreaded::test_multithreaded_breakpoints"
    "--skip=multithreaded::test_multithreaded_trace"
    "--skip=signal::test_signal_stop_multi_thread"
    "--skip=signal::test_signal_stop_multi_thread_multiple_signal"
    "--skip=signal::test_signal_stop_single_thread"
    "--skip=signal::test_transparent_signals"
    "--skip=steps::test_step_into"
    "--skip=steps::test_step_into_recursion"
    "--skip=steps::test_step_out"
    "--skip=steps::test_step_over"
    "--skip=steps::test_step_over_inline_code"
    "--skip=steps::test_step_over_on_fn_decl"
    "--skip=symbol::test_symbol"
    "--skip=test_debugger_disassembler"
    "--skip=test_debugger_graceful_shutdown"
    "--skip=test_debugger_graceful_shutdown_multithread"
    "--skip=test_frame_cfa"
    "--skip=test_registers"
    "--skip=variables::test_arguments"
    "--skip=variables::test_btree_map"
    "--skip=variables::test_cast_pointers"
    "--skip=variables::test_cell"
    "--skip=variables::test_circular_ref_types"
    "--skip=variables::test_lexical_blocks"
    "--skip=variables::test_read_array"
    "--skip=variables::test_read_atomic"
    "--skip=variables::test_read_btree_set"
    "--skip=variables::test_read_closures"
    "--skip=variables::test_read_enum"
    "--skip=variables::test_read_hashmap"
    "--skip=variables::test_read_hashset"
    "--skip=variables::test_read_only_local_variables"
    "--skip=variables::test_read_pointers"
    "--skip=variables::test_read_scalar_variables"
    "--skip=variables::test_read_scalar_variables_at_place"
    "--skip=variables::test_read_static_in_fn_variable"
    "--skip=variables::test_read_static_variables"
    "--skip=variables::test_read_static_variables_different_modules"
    "--skip=variables::test_read_strings"
    "--skip=variables::test_read_struct"
    "--skip=variables::test_read_tls_variables"
    "--skip=variables::test_read_type_alias"
    "--skip=variables::test_read_union"
    "--skip=variables::test_read_uuid"
    "--skip=variables::test_read_vec_and_slice"
    "--skip=variables::test_read_vec_deque"
    "--skip=variables::test_shared_ptr"
    "--skip=variables::test_slice_operator"
    "--skip=variables::test_type_parameters"
    "--skip=variables::test_zst_types"
  ];

  meta = {
    description = "Rust debugger for Linux x86-64";
    homepage = "https://github.com/godzie44/BugStalker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jacg ];
    mainProgram = "bs";
    platforms = [ "x86_64-linux" ];
  };
}
