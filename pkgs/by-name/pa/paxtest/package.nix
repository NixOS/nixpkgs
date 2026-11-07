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
    description = "Test various memory protection measures";
    mainProgram = "paxtest";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
