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
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9/kFI38PG3AKsdDqEV/wEzSel9IlQQ/pvOyhU/N/aV0=";
  };

  nativeBuildInputs = [ which ];
  buildInputs = lib.optionals stdenv.hostPlatform.isFreeBSD [ gettext ];

  # configure script is not autotools-based, doesn't support these options
  dontAddStaticConfigureFlags = true;

  configurePlatforms = [ ];

  configureFlags = [
    "--ar=${stdenv.cc.targetPrefix}ar"
    "--target=${stdenv.hostPlatform.config}"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableStatic "lib-static")
  ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [
    "install"
    "install-lib-headers"
  ]
  ++ lib.optionals (!enableStatic) [
    "install-lib-so-link"
  ];

  meta = {
    homepage = "https://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
