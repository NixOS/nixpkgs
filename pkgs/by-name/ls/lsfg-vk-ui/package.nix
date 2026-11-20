{
  lib,
  stdenv,
  fetchgit,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsfg-vk-ui";
  version = "2.0.0";

  src = fetchgit {
    url = "https://git.lsfg-vk.dev/lsfg-vk.git";
    tag = finalAttrs.version;
    hash = "sha256-vp0/adJdVV73C2RFjcEE90KjWiZJQhiqqOlYQ89RG+Y=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [ qt6.qtdeclarative ];

  cmakeFlags = [
    (lib.cmakeBool "LSFGVK_MANAGED" true)
    (lib.cmakeBool "LSFGVK_BUILD_LAYER" false)
    (lib.cmakeBool "LSFGVK_BUILD_UI" true)
    (lib.cmakeBool "LSFGVK_BUILD_CLI" false)
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Graphical configuration interface for lsfg-vk";
    homepage = "https://lsfg-vk.dev/";
    license = lib.licenses.cc-by-nc-nd-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Gliczy
      pabloaul
    ];
    mainProgram = "lsfg-vk-ui";
  };
})
