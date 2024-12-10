{ lib, stdenv, fetchurl, autoreconfHook
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsodium";
  version = "1.0.20";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/libsodium-${finalAttrs.version}.tar.gz";
    hash = "sha256-67Ze9spDkzPCu0GgwZkFhyiNoH9sf9B8s6GMwY0wzhk=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook ];

  separateDebugInfo = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.libc != "musl";

  enableParallelBuilding = true;
  hardeningDisable = lib.optional (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_32) "stackprotector";

  # FIXME: the hardeingDisable attr above does not seems effective, so
  # the need to disable stackprotector via configureFlags
  configureFlags = lib.optional (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_32) "--disable-ssp";

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Modern and easy-to-use crypto library";
    homepage = "https://doc.libsodium.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ raskin ];
    pkgConfigModules = [ "libsodium" ];
    platforms = platforms.all;
  };
})
