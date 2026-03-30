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
  version = "1.0.21-unstable-2026-03-29";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libsodium";
    rev = "d1d0bedbac5b415711a92bb4b881cea73f318c93";
    hash = "sha256-AL41r5N80rUJYu852qdisTwMbaOQ1vAdB/2j82kGqT0=";
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
