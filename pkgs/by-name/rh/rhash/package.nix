{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  enableStatic ? stdenv.hostPlatform.isStatic,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.4.6";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9/kFI38PG3AKsdDqEV/wEzSel9IlQQ/pvOyhU/N/aV0=";
  };

  nativeBuildInputs = [ which ];
  buildInputs = lib.optionals stdenv.hostPlatform.isFreeBSD [ gettext ];

  strictDeps = true;

  # configure script is not autotools-based, doesn't support these options
  dontAddStaticConfigureFlags = true;

  configurePlatforms = [ ];

  configureFlags = [
    "--ar=${stdenv.cc.targetPrefix}ar"
    "--target=${stdenv.hostPlatform.config}"
    "--disable-shani"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableStatic "lib-static")
  ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [
    "install"
    "install-lib-headers"
  ]
  ++ lib.optionals (!enableStatic && !stdenv.hostPlatform.isWindows) [
    "install-lib-so-link"
  ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ graysontinker ];
  };
})
