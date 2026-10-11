{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchurl,
  autoreconfHook,
  dejagnu,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ltrace";
  version = "0.8.1";

  src = fetchFromGitLab {
    owner = "cespedes";
    repo = "ltrace";
    tag = finalAttrs.version;
    hash = "sha256-U4ZirTnS7X2GB4tMcHrrecvOOfY1xWp59sSqJga75uU=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ elfutils ];
  nativeCheckInputs = [ dejagnu ];

  patches = [
    # print-instruction-pointer.exp doesn't expect ASLR
    (fetchurl {
      url = "https://github.com/gentoo/gentoo/raw/a2eb7e103ec985ff90f59e722e0a8a43373972a2/dev-debug/ltrace/files/ltrace-0.7.3-print-test-pie.patch";
      hash = "sha256-QRsUoN3WLzfiY5GDPwVYXtJPFMJt6rcc6eE96SAtI6Q=";
    })
    # fix pointer conversion warning with GCC 15
    # https://gitlab.com/cespedes/ltrace/-/merge_requests/28
    ./trace-clone-gcc15.patch
    # fix demangle test with GCC 16
    # https://gitlab.com/cespedes/ltrace/-/merge_requests/112
    ./demangle-gcc16.patch
  ];

  doCheck = true;
  checkPhase =
    let
      ignoredTests = [
        # Require ptrace-ing a non-child process, this might be forbidden by
        # YAMA ptrace policy on the build host.
        "attach-process.exp"
        "attach-process-dlopen.exp"
        # Expectations not updated for the output format changes in 0.8.0
        # (e.g. "{ 1, 2 }" -> "{1, 2}")
        "dwarf.exp"
        "parameters.exp"
        "parameters2.exp"
        "parameters-hfa.exp"
        "wchar.exp"
      ];
    in
    ''
      runHook preCheck

      # Hardening options interfere with some of the low-level expectations in
      # the test suite (e.g. printf ends up redirected to __printf_chk).
      export NIX_HARDENING_ENABLE=
      # ltrace formats wide characters according to its own locale.
      export LC_ALL=C.UTF-8
      make check RUNTESTFLAGS="--host=${stdenv.hostPlatform.config} \
                               --target=${stdenv.targetPlatform.config} \
                               --ignore '${lib.concatStringsSep " " ignoredTests}'"

      runHook postCheck
    '';

  meta = {
    description = "Library call tracer";
    mainProgram = "ltrace";
    homepage = "https://www.ltrace.org/";
    changelog = "https://gitlab.com/cespedes/ltrace/-/blob/${finalAttrs.version}/NEWS";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
