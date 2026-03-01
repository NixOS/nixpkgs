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
  version = "1.0.21-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libsodium";
    rev = "f6c18801a8a9be6a1bef4af177098b8de88f7880";
    hash = "sha256-TFPyC6JzkDQe1er4GfaM2TzSRTXqm5XS8Sxq2V6grLM=";
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
