{
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  lib,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sierra-breeze-enhanced";
  version = "2.1.1-unstable-2025-10-14";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = "SierraBreezeEnhanced";
    rev = "4a4f085aa5c48ad11071dee4e92289c2cc4a36cd";
    hash = "sha256-dOIC2EQqninEIktVK6dLctzN/IiQIRvp1Qmcop9h7Dw=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    kdePackages.kwin
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  passthru.updateScript = unstableGitUpdater {
    branch = "master";
  };

  meta = {
    description = "OSX-like window decoration for KDE Plasma written in C++";
    homepage = "https://github.com/kupiqu/SierraBreezeEnhanced";
    changelog = "https://github.com/kupiqu/SierraBreezeEnhanced/compare/V.2.1.1...${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ A1ca7raz ];
  };
})
