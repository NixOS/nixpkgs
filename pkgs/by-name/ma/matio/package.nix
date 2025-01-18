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
  version = "1.5.28";

  src = fetchurl {
    url = "mirror://sourceforge/matio/matio-${finalAttrs.version}.tar.gz";
    hash = "sha256-naaYk0ohVprwWOY0hWRmb0UCnmwrCHjKDY+WCb93uNg=";
  };

  configureFlags = [ "ac_cv_va_copy=1" ];

  nativeBuildInputs = [
    pkgconf
    validatePkgConfig
  ];

  buildInputs = [
    hdf5
    zlib
  ];

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
    changelog = "https://sourceforge.net/p/matio/news/";
    description = "C library for reading and writing Matlab MAT files";
    homepage = "https://matio.sourceforge.net/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "matdump";
    platforms = lib.platforms.all;
    pkgConfigModules = [ "matio" ];
  };
})
