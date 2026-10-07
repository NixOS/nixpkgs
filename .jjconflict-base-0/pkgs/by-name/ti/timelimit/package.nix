{
  lib,
  stdenv,
  fetchFromGitLab,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timelimit";
  version = "1.9.5";

  src = fetchFromGitLab {
    owner = "timelimit";
    repo = "timelimit";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-nsjLRRIsDv4QJq73nCjd0r4zQbyaQsriPz/gDWu4K18=";
  };

  nativeCheckInputs = [ perl ];
  doCheck = true;

  installFlags = [ "PREFIX=$(out)" ];

  env = {
    INSTALL_PROGRAM = "install -m755";
    INSTALL_DATA = "install -m644";
  };

  meta = {
    description = "Execute a command and terminates the spawned process after a given time with a given signal";
    homepage = "https://devel.ringlet.net/sysutils/timelimit/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      sheeeng
    ];
    mainProgram = "timelimit";
  };
})
