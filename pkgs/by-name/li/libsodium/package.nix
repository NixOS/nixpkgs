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
  version = "1.0.22-unstable-2026-09-28";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libsodium";
    rev = "9dcaa81943641565585482c20f2a211200aa1d89";
    hash = "sha256-QQlxeUgQDdFweGqsUOso+II64zMfjmmB2sUuF3Vu53o=";
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
    ];
    teams = [ lib.teams.security-review ];
    pkgConfigModules = [ "libsodium" ];
    platforms = lib.platforms.all;
  };
})
