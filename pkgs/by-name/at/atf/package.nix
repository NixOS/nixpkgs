{
  lib,
  stdenv,
<<<<<<< HEAD
  darwin,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  kyua,
  gitUpdater,
}:

<<<<<<< HEAD
let
  # atf is a dependency of libiconv. Avoid an infinite recursion with `pkgsStatic` by using a bootstrap stdenv.
  stdenv' = if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation (finalAttrs: {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "atf";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "atf";
    tag = "atf-${finalAttrs.version}";
    hash = "sha256-g9cXeiCaiyGQXtg6eyrbRQpqk4VLGSFuhfPB+ynbDIo=";
  };

  postPatch =
    lib.optionalString finalAttrs.doInstallCheck ''
      # Can’t find `c_helpers` in the work folder.
      substituteInPlace test-programs/Kyuafile \
        --replace-fail 'atf_test_program{name="srcdir_test"}' ""
    ''
    # These tests fail on Darwin.
<<<<<<< HEAD
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv'.hostPlatform.isDarwin) ''
=======
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isDarwin) ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      substituteInPlace atf-c/detail/process_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, status_coredump);' ""
    ''
    # This test fails on Linux.
<<<<<<< HEAD
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv'.hostPlatform.isLinux) ''
=======
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isLinux) ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      substituteInPlace atf-c/detail/fs_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, eaccess);' ""
    '';

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  makeFlags = [
    # ATF isn’t compatible with C++17, which is the default on current clang and GCC.
    "CXXFLAGS=-std=c++14"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    kyua
  ];

  # Don’t install the test programs for ATF itself; they’re useless
  # other than as part of the `installCheckPhase`, and they contain
  # non‐reproducible references to the build directory.
  postInstall = ''
    rm -r $out/tests
  '';

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
