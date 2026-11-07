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

  # https://github.com/opensrcsec/paxtest/pull/1
  postPatch = ''
    substituteInPlace src/Makefile.psm \
      --replace-fail 'chmod 755 ../$@' 'chmod 755 $@'
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
