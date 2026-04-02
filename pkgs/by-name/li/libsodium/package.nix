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
  version = "1.0.21-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libsodium";
    rev = "e18eee6532f5dc4b0f7ee99024e24bf4c8e12fc2";
    hash = "sha256-S/uQtt4m5OyGo9yBb4UARV0Xcwtd/I6tCRJilcx8XBM=";
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
    teams = [ lib.teams.security-review ];
    pkgConfigModules = [ "libsodium" ];
    platforms = lib.platforms.all;
  };
})
