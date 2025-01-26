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
  version = "0.22";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "atf";
    tag = "atf-${finalAttrs.version}";
    hash = "sha256-vZfBk/lH+04d3NbTUYjAaxwGFHtnagl/kY04hgkE4Iw=";
  };

  patches = [
    # https://github.com/freebsd/atf/issues/88
    # https://github.com/freebsd/atf/pull/85
    # Maintainer say it fix some tests in issue 88.
    ./pr-85.patch
    (fetchpatch {
      url = "https://github.com/freebsd/atf/commit/b42c98612cb99fa3f52766a46203263dc1de7187.patch?full_index=1";
      hash = "sha256-goDPIdIF8vHXDengVIYbxw5W/JT5kfsG5japgtranas=";
    })
  ];

  postPatch =
    lib.optionalString finalAttrs.doInstallCheck ''
      # Can’t find `c_helpers` in the work folder.
      substituteInPlace test-programs/Kyuafile \
        --replace-fail 'atf_test_program{name="srcdir_test"}' ""
    ''
    # These tests fail on Darwin.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isDarwin) ''
      substituteInPlace atf-c/detail/process_test.c \
        --replace-fail 'ATF_TP_ADD_TC(tp, status_coredump);' ""
    ''
    # This test fails on Linux.
    + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isLinux) ''
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
