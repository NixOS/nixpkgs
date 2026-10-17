{
  stdenv,
  lib,
  fetchFromGitLab,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzakalwe";
  version = "1.0.0-unstable-2026-09-20";

  src = fetchFromGitLab {
    owner = "hors";
    repo = "libzakalwe";
    rev = "f40771d472d1a3846969678d893846a48c16b025";
    hash = "sha256-E1X0mWvLsQuu9jo72IFx2VWTAcrjWtv+2EMhAdbxEv0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail 'libzakalwe.so' "libzakalwe${stdenv.hostPlatform.extensions.sharedLibrary}"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.in \
      --replace-fail '-soname' '-install_name'
  '';

  strictDeps = true;

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_DARWIN_C_SOURCE";

  # Darwin: Assertion failed at thread_util_test_0:52: tr != NULL
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform && (!stdenv.hostPlatform.isDarwin);

  installFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/lib
  '';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "Library for functions shared across zakalwe projects";
    homepage = "https://gitlab.com/hors/libzakalwe";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
  };
})
