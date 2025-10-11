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

  doCheck = true;
  checkPhase = ''
    # Hardening options interfere with some of the low-level expectations in
    # the test suite (e.g. printf ends up redirected to __printf_chk).
    NIX_HARDENING_ENABLE="" \
    # Disable test that requires ptrace-ing a non-child process, this might be
    # forbidden by YAMA ptrace policy on the build host.
    RUNTESTFLAGS="--host=${stdenv.hostPlatform.config} \
                  --target=${stdenv.targetPlatform.config} \
                  --ignore attach-process.exp" \
      make check
  '';

  meta = {
    changelog = "https://gitlab.com/cespedes/ltrace/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "Library call tracer";
    mainProgram = "ltrace";
    homepage = "https://www.ltrace.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
