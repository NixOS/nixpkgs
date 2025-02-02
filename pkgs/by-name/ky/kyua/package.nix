{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  autoreconfHook,
  lutok,
  pkg-config,
  sqlite,
  unstableGitUpdater,
}:

let
  # Avoid an infinite recursion (because ATF uses Kyua for testing).
  atf' = atf.overrideAttrs (_: {
    doInstallCheck = false;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kyua";
  version = "0.13-unstable-2024-01-22"; # Match the commit used in FreeBSD’s port.

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "kyua";
    rev = "c85354e09ad93a902c9e8a701c042c045ec2a5b7";
    hash = "sha256-fZ0WFgOTj8Gw8IT5O8DnuaNyZscKpg6B94m+l5UoZGc";
  };

  setupHooks = ./kyua-check-hook.sh;

  postPatch =
    ''
      # Fix a linking error on Darwin. Embedding an archive in an archive isn’t portable.
      substituteInPlace cli/Makefile.am.inc \
        --replace-fail 'libcli_a_LIBADD = libutils.a' "" \
        --replace-fail 'CLI_LIBS = ' 'CLI_LIBS = libutils.a '
    ''
    # These tests fail on Darwin or are unreliable.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isDarwin) ''
      sed -i utils/process/Makefile.am.inc -e '/executor_pid_test/d'
      substituteInPlace utils/process/Kyuafile \
        --replace-fail 'atf_test_program{name="executor_pid_test"}' ""
      substituteInPlace engine/atf_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, test__body_only__crashes);' ""
      substituteInPlace engine/scheduler_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, integration__stacktrace);' ""
      substituteInPlace utils/stacktrace_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, unlimit_core_size);' ""
      substituteInPlace utils/process/isolation_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, isolate_child__enable_core_dumps);' ""
      substituteInPlace utils/process/operations_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, terminate_self_with__termsig_and_core);' ""
      substituteInPlace utils/process/status_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, integration__coredump);' ""
      substituteInPlace integration/cmd_test_test.sh \
        --replace-fail 'atf_add_test_case premature_exit' ""
    ''
    # fchflags and UF_NOUNLINK are not supported on Linux. Other tests also fail.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isLinux) ''
      sed -i utils/process/Makefile.am.inc -e '/executor_pid_test/d'
      substituteInPlace utils/process/Kyuafile \
        --replace-fail 'atf_test_program{name="executor_pid_test"}' ""
      substituteInPlace engine/atf_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, test__body_only__crashes);' ""
      substituteInPlace utils/stacktrace_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, dump_stacktrace__ok);' "" \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, dump_stacktrace_if_available__append);' "" \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, find_core__found__long);' "" \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, find_core__found__short);' "" \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, unlimit_core_size__hard_is_zero);' ""
      substituteInPlace integration/cmd_test_test.sh \
        --replace-fail 'atf_add_test_case premature_exit' ""
    '';

  strictDeps = true;

  buildInputs = [
    lutok
    sqlite
  ];

  nativeBuildInputs = [
    atf'
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  makeFlags = [
    # Kyua isn’t compatible with C++17, which is the default on current clang and GCC.
    "CXXFLAGS=-std=c++11"
  ];

  doInstallCheck = true;

  installCheckInputs = [ atf' ];
  nativeInstallCheckInputs = [ sqlite ];

  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$TMPDIR PATH=$out/bin:$PATH kyua test
    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "kyua-"; };

  __structuredAttrs = true;

  meta = {
    description = "Testing framework for infrastructure software";
    homepage = "https://github.com/freebsd/kyua/";
    changelog = "https://github.com/freebsd/kyua/blob/master/NEWS.md";
    license = lib.licenses.bsd3;
    mainProgram = "kyua";
    maintainers = with lib.maintainers; [ reckenrode ];
    platforms = lib.platforms.unix;
  };
})
