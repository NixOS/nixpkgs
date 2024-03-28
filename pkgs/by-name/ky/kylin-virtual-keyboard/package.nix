{ lib
, stdenv
, fetchgit
, pkg-config
, libsForQt5
, wrapGAppsHook
, gsettings-qt
, glib
}:
let
  inherit (libsForQt5) qmake qttools qtwayland qtquickcontrols2 qtdeclarative qtgraphicaleffects wrapQtAppsHook fcitx5-qt kwindowsystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kylin-virtual-keyboard";
  version = "2.0.4.0-0ok5";

  src = fetchgit {
    url = "https://gitee.com/openkylin/kylin-virtual-keyboard";
    rev = "build/${finalAttrs.version}";
    hash = "sha256-KtXsa6ZC5GlxpjjQQB6OoHgZn7SEhybD5gRDtw5MbSY=";
  };

  postPatch = ''
    substituteInPlace kylin-virtual-keyboard.pro \
     data/org.fcitx.Fcitx5.VirtualKeyboard.service \
     debian/{kylin-virtual-keyboard.desktop,kylin-virtual-keyboard-xwayland} \
      --replace /usr $out
  '';

  nativeBuildInputs = [
    qmake
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook
    glib # for gsettings-schemas
  ];

  dontWrapGApps = true;

  buildInputs = [
    gsettings-qt
    kwindowsystem
    fcitx5-qt
    qtwayland
    qtquickcontrols2
    qtdeclarative
    qtgraphicaleffects
  ];

  postInstall = ''
    install -D data/org.fcitx.Fcitx5.VirtualKeyboard.service -t $out/share/dbus-1/services/
    install -D debian/kylin-virtual-keyboard.desktop -t $out/etc/xdg/autostart/
    install -D debian/kylin-virtual-keyboard-xwayland -t $out/bin/
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${finalAttrs.pname}-${finalAttrs.version}"}
  '';

  meta = {
    description = "Virtual keyboard based on fcitx5 InputMethod Framework";
    homepage = "https://gitee.com/openkylin/kylin-virtual-keyboard";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ rewine ];
    platforms = lib.platforms.linux;
    mainProgram = "kylin-virtual-keyboard";
  };
})
