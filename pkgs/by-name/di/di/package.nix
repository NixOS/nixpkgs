{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "di";
  version = "6.2.2.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/di-${finalAttrs.version}.tar.gz";
    hash = "sha256-Ge7rfrytMGGueBTNrlWTrM+yuyYc4keVpgSigsv8YP4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://diskinfo-di.sourceforge.io/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    mainProgram = "di";
  };
})
