{
  cmake,
  ctestCheckHook,
  fetchFromGitHub,
  gettext,
  gtest,
  kdePackages,
  lib,
  libqalculate,
  mpfr,
  nix-update-script,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-applet-qalculate";
  version = "0.11.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dschopf";
    repo = "plasma-applet-qalculate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KWdb/TDUuYONU3fbGF5qs9zOzjpz+siDqCMVJlN6NNQ=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
    pkg-config
  ];
  buildInputs = [
    kdePackages.ki18n
    kdePackages.libplasma
    libqalculate
    mpfr
  ];
  dontWrapQtApps = true;

  doCheck = true;
  cmakeFlags = [ (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck) ];
  nativeCheckInputs = [ ctestCheckHook ];
  checkInputs = [ gtest ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qalculate applet for plasma desktop";
    homepage = "https://github.com/dschopf/plasma-applet-qalculate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xelacodes ];
    platforms = lib.platforms.linux;
  };
})
