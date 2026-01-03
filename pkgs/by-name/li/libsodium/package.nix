{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  testers,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsodium";
  version = "1.0.20-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libsodium";
    rev = "d44593f1a5b7d31b5122689605b489577356f7e8";
    hash = "sha256-6DC9JJLUwAoZHrYdCIiqOtAlWOEczec2r2FmaBbsa/Q=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  separateDebugInfo = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.libc != "musl";

  enableParallelBuilding = true;
  hardeningDisable = lib.optional (
    stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_32
  ) "stackprotector";

  # FIXME: the hardeingDisable attr above does not seems effective, so
  # the need to disable stackprotector via configureFlags
  configureFlags = lib.optional (
    stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_32
  ) "--disable-ssp";

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = unstableGitUpdater {
      branch = "stable";
      tagConverter = "cut -d - -f 1";
    };
  };

  meta = {
    description = "Modern and easy-to-use crypto library";
    homepage = "https://doc.libsodium.org/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      mdaniels5757
      raskin
    ];
    pkgConfigModules = [ "libsodium" ];
    platforms = lib.platforms.all;
  };
})
