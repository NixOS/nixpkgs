{
  lib,
  stdenv,
  fetchurl,
  bzip2,
  glib,
  libgcrypt,
  perl,
  pkg-config,
  pkgConfigCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspectrum";
  version = "1.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/libspectrum-${finalAttrs.version}.tar.gz";
    hash = "sha256-OjMi+QbwVJhxY8LpcHFgt82jAu5G1kERx8tuwzrcnQQ=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    bzip2
    glib
    zlib
  ];

  propagatedBuildInputs = [ libgcrypt ];

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ pkgConfigCheckHook ];

  enableParallelBuilding = true;
  pkgConfigModules = [ "libspectrum" ];

  meta = {
    description = "ZX Spectrum input and output support library";
    homepage = "https://fuse-emulator.sourceforge.net/libspectrum.php";
    changelog = "https://sourceforge.net/p/fuse-emulator/libspectrum/ci/libspectrum-${finalAttrs.version}/tree/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libspectrum" ];
  };
})
