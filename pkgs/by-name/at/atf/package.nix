{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  autoreconfHook,
  kyua,
  gitUpdater,
}:

let
  # atf is a dependency of libiconv. Avoid an infinite recursion with `pkgsStatic` by using a bootstrap stdenv.
  stdenv' = if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "atf";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "atf";
    tag = "atf-${finalAttrs.version}";
    hash = "sha256-YdxmkrJIQpOd48RSgQwPgLD76KzKFONc5vlqOaNKIcU=";
  };

  postPatch =
    lib.optionalString finalAttrs.doInstallCheck ''
      # Can’t find `c_helpers` in the work folder.
      substituteInPlace test-programs/Kyuafile \
        --replace-fail 'atf_test_program{name="srcdir_test"}' ""
    ''
    # These tests fail on Darwin.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv'.hostPlatform.isDarwin) ''
      substituteInPlace atf-c/detail/process_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, status_coredump);' ""
    ''
    # This test fails on Linux.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv'.hostPlatform.isLinux) ''
      substituteInPlace atf-c/detail/fs_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, eaccess);' ""
    '';

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "ATF_SHELL=${darwin.bootstrapStdenv.shell}"
    ]
    # When cross-compiling, autoconf cannot run test programs on the build host.
    # Pre-set cache variables so configure skips those AC_RUN_IFELSE checks.
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "kyua_cv_getopt_plus=yes"
      "kyua_cv_attribute_noreturn=yes"
      "kyua_cv_getcwd_works=yes"
    ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    kyua
  ];

  # ATF expects to run the installed tests. Run them as part of check phase then delete them to avoid creating
  # references to the ATF build products.
  installCheckPhase = ''
    runHook preInstallCheck
    cd $out/tests/atf
    HOME=$TMPDIR PATH=$out/bin:$PATH kyua test
    rm -rf $out/tests
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
