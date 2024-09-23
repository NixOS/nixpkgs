{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  kyua,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atf";
  version = "0.21-unstable-2021-09-01"; # Match the commit used in FreeBSD’s port.

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "atf";
    rev = "55c21b2c5fb189bbdfccb2b297bfa89236502542";
    hash = "sha256-u0YBPcoIBvqBVaytaO9feBaRnQygtzEPGJV0ItI1Vco=";
  };

  patches = [
    # Fixes use after free that causes failures in Kyua’s test suite.
    # https://github.com/freebsd/atf/pull/57
    # https://github.com/freebsd/kyua/issues/223
    (fetchpatch {
      name = "fix-use-after-free.patch";
      url = "https://github.com/freebsd/atf/commit/fb22f3837bcfdce5ce8b3c0e18af131bb6902a02.patch";
      hash = "sha256-p4L3sxSYfMSzwKrUDlEZpoJydbaK3Hcbvn90KlPHkic=";
    })
  ];

  postPatch =
    lib.optionalString finalAttrs.doInstallCheck ''
      # https://github.com/freebsd/atf/issues/61
      substituteInPlace atf-c/check_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, build_cpp)' ""
      substituteInPlace atf-c++/check_test.cpp \
        --replace-fail 'ATF_ADD_TEST_CASE(tcs, build_cpp);' ""
      # Can’t find `c_helpers` in the work folder.
      substituteInPlace test-programs/Kyuafile \
        --replace-fail 'atf_test_program{name="srcdir_test"}' ""
    ''
    # These tests fail on Darwin.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.isDarwin) ''
      substituteInPlace atf-c/detail/process_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, status_coredump);' ""
    ''
    # This test fails on Linux.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.isLinux) ''
      substituteInPlace atf-c/detail/fs_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, eaccess);' ""
    '';

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  makeFlags = [
    # ATF isn’t compatible with C++17, which is the default on current clang and GCC.
    "CXXFLAGS=-std=c++11"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ kyua ];

  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$TMPDIR PATH=$out/bin:$PATH kyua test
    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "atf-"; };

  __structuredAttrs = true;

  meta = {
    description = "Libraries to write tests in C, C++, and shell";
    homepage = "https://github.com/freebsd/atf/";
    license = lib.licenses.bsd3;
    mainProgram = "atf-sh";
    maintainers = with lib.maintainers; [ reckenrode ];
    platforms = lib.platforms.unix;
  };
})
