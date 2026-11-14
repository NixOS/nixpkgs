{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paxtest";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "opensrcsec";
    repo = "paxtest";
    tag = "paxtest-${finalAttrs.version}";
    hash = "sha256-ynlLIcIJm22Padl5Rmw7bq62Vm3orrs/nr4iJE64jXc=";
  };

  nativeBuildInputs = [ which ];

  enableParallelBuilding = true;

  postPatch = ''
    # https://github.com/opensrcsec/paxtest/pull/1
    substituteInPlace src/Makefile.psm \
      --replace-fail 'chmod 755 ../$@' 'chmod 755 $@'

    # aarch64 falls back to the x86 `ret` shellcode (SIGILL)
    substituteInPlace src/shellcode.h \
      --replace-fail '#elif defined(__arm__) && !defined(__arch64__)' '#elif defined(__aarch64__)
    #define SHELLCODE_RETURN "\xc0\x03\x5f\xd6"
    #elif defined(__arm__) && !defined(__arch64__)'

    # chpax fails on aarch64, setting PaX flags is best effort anyway
    # https://hydra.nixos.org/build/352872657/step/2/log
    echo 'exit 0' >> contrib/setpaxflags
  '';

  makefile = "Makefile.psm";

  makeFlags = [
    "-C"
    "src"
    "BINDIR=$(out)/bin"
    "RUNDIR=$(out)/lib/paxtest"
  ];

  installFlags = [ "DESTDIR=\"\"" ];

  meta = {
    description = "Memory protection and randomization tests";
    homepage = "https://github.com/opensrcsec/paxtest";
    changelog = "https://github.com/opensrcsec/paxtest/blob/${finalAttrs.src.tag}/ChangeLog";
    mainProgram = "paxtest";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ samirbgno ];
  };
})
