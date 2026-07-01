{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  nettle,
  gnutls,
  libdrm,
  libGL,
  libpng,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gavl";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "bplaum";
    repo = "gavl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nvgBsUiSF6+voMzo5XRWHig2Iq8DD2hVV5hWodGxgQo=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags = [
    # disable -march=native
    (lib.withFeatureAs true "cpuflags" "none")
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    nettle
    gnutls
    libdrm
    libGL
    libpng
  ];

  doCheck = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    homepage = "https://github.com/bplaum/gavl";
    description = "Support library for other packages of the gmerlin project";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.christoph-heiss ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "gavl" ];
  };
})
