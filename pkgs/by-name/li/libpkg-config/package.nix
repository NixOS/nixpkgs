{
  lib,
  stdenv,
  # Dependency of build2, so we must break cycle for this
  build2-bootstrap,
  darwin,
  fetchurl,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpkg-config";
  version = "0.1.4";

  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/libpkg-config/libpkg-config-${finalAttrs.version}.tar.gz";
    hash = "sha256-1WhB2D1W/piNU8dJB0V37ZiOU6CWneapq4mqS5ypoN0=";
  };

  nativeBuildInputs = [
    build2-bootstrap
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools
  ];

  __structuredAttrs = true;
  strictDeps = true;

  # Should be true for anything built with build2,
  # but especially important when bootstrapping
  disallowedReferences = [ build2-bootstrap ];

  build2ConfigureFlags = [
    "config.bin.lib=${build2-bootstrap.configSharedStatic enableShared enableStatic}"
  ];

  doCheck = true;

  meta = {
    description = "Fork of libpkgconf for build2";
    homepage = "https://build2.org/";
    downloadPage = "https://github.com/build2/libpkg-config";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ AAAAAASomeThingsFailToEvaluate ];
    platforms = lib.platforms.all;
  };
})
