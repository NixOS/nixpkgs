{
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  kwin,
  lib,
}:
stdenv.mkDerivation rec {
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
    extra-cmake-modules
    wrapQtAppsHook
  ];
  buildInputs = [ kwin ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  meta = {
    description = "OSX-like window decoration for KDE Plasma written in C++";
    homepage = "https://github.com/kupiqu/SierraBreezeEnhanced";
    changelog = "https://github.com/kupiqu/SierraBreezeEnhanced/releases/tag/V${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ A1ca7raz ];
  };
}
