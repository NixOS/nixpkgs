{
  fetchurl,
  hdf5,
  lib,
  matio,
  nix-update-script,
  pkgconf,
  stdenv,
  testers,
  validatePkgConfig,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matio";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/tbeu/matio/releases/download/v${finalAttrs.version}/matio-${finalAttrs.version}.tar.gz";
    hash = "sha256-FIHcdOAdJJ6Q8GQzP5aTaf490R1sxpY+hjXFgapddxE=";
  };

  configureFlags = [ "ac_cv_va_copy=C99" ];

  nativeBuildInputs = [
    pkgconf
    validatePkgConfig
  ];

  buildInputs = [
    hdf5
    zlib
  ];

  doCheck = true;

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = matio;
        versionCheck = true;
      };
      version = testers.testVersion {
        package = matio;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/tbeu/matio/releases/tag/v${finalAttrs.version}";
    description = "C library for reading and writing Matlab MAT files";
    homepage = "https://matio.sourceforge.net/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "matdump";
    platforms = lib.platforms.all;
    pkgConfigModules = [ "matio" ];
  };
})
