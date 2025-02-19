{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  makeWrapper,
  python3,
  glib,
  nix-update-script,
}:
let
  pythonEnv = python3.withPackages (p: [
    p.dbus-python
    p.pygobject3
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-panel-colorizer";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-colorizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YDYVjAbizmo1+E1DVeyISKM4Jb/HkKY/On9RanJBuvI=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    makeWrapper
  ];

  buildInputs = [ kdePackages.plasma-desktop ];

  dontWrapQtApps = true;
  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_PLASMOID" true)
    (lib.cmakeBool "BUILD_PLUGIN" true)
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  patches = [ ./use-dbus-service-directly.patch ];

  postPatch = ''
    substituteInPlace package/contents/ui/tools/service.py \
      --replace-fail '#!/usr/bin/env python' '#!${lib.getExe pythonEnv}'
  '';

  postInstall = ''
    chmod 755 $out/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/tools/{list_presets.sh,service.py}

    wrapProgram $out/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/tools/service.py \
      --prefix GI_TYPELIB_PATH : "${glib.out}/lib/girepository-1.0"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/luisbocanegra/plasma-panel-colorizer/blob/main/CHANGELOG.md";
    description = "Fully-featured widget to bring Latte-Dock and WM status bar customization features to the default KDE Plasma panel";
    homepage = "https://github.com/luisbocanegra/plasma-panel-colorizer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
