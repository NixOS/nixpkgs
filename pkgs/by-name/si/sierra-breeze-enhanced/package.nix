{
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sierra-breeze-enhanced";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = "SierraBreezeEnhanced";
    tag = if finalAttrs.version == "2.1.1" then "V.2.1.1" else "V${finalAttrs.version}";
    hash = "sha256-7mQnJCQr/zm9zEdg2JPr7jQn8uajyCXvyYRQZWxG+Q8=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);
  buildInputs = with kdePackages; [ kwin ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  meta = {
    description = "OSX-like window decoration for KDE Plasma written in C++";
    homepage = "https://github.com/kupiqu/SierraBreezeEnhanced";
    changelog = "https://github.com/kupiqu/SierraBreezeEnhanced/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ A1ca7raz ];
  };
})
