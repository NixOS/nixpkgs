{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
  glib,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-panel-colorizer";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-colorizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7qSky/wY5l72EVhTGnwQ8lI3Uu3TnZpgqXaClCxWZQ=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.plasma-desktop
  ];

  patches = [
    ./fix-cmds.patch
  ];

  postPatch = ''
    substituteInPlace package/contents/ui/DBusFallback.qml \
      --replace-fail "@glib@" "${glib}"
    substituteInPlace package/contents/ui/configPresetAutoload.qml \
      --replace-fail "@runtimeShell@" "${runtimeShell}"
    substituteInPlace package/contents/ui/configPresets.qml \
      --replace-fail "@runtimeShell@" "${runtimeShell}"
    substituteInPlace package/contents/ui/main.qml \
      --replace-fail "@runtimeShell@" "${runtimeShell}"
  '';

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_PLASMOID" true)
    (lib.cmakeBool "BUILD_PLUGIN" true)
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fully-featured widget to bring Latte-Dock and WM status bar customization features to the default KDE Plasma panel";
    homepage = "https://github.com/luisbocanegra/plasma-panel-colorizer";
    changelog = "https://github.com/luisbocanegra/plasma-panel-colorizer/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
