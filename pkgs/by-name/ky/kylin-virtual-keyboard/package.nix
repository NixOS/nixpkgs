{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  glib,
  fcitx5,
  gsettings-qt,
  bashNonInteractive,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kylin-virtual-keyboard";
  version = "4.20.1.0";

  src = fetchFromGitHub {
    owner = "openkylin";
    repo = "kylin-virtual-keyboard";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-YM5FLJcgjhx7Ks1bgC26Ee4oDF8C6dK8yTtXSnD84aA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    libsForQt5.qtgraphicaleffects
    glib
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qtquickcontrols2
    libsForQt5.qtsvg
    fcitx5
    libsForQt5.fcitx5-qt
    libsForQt5.kwindowsystem
    gsettings-qt
  ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc/xdg/autostart" "${placeholder "out"}/etc/xdg/autostart"

    substituteInPlace \
      data/{kylin-virtual-keyboard-xwayland,kylin-virtual-keyboard.desktop,org.fcitx.Fcitx5.VirtualKeyboard.service} \
        --replace-fail "/usr" "${placeholder "out"}"
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
    substituteInPlace $out/bin/kylin-virtual-keyboard-xwayland \
      --replace-fail "#!/bin/bash" "#!${lib.getExe bashNonInteractive}"
  '';

  postFixup = ''
    wrapProgram $out/bin/$pname \
      --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/$pname-$version"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern on-screen keyboard for Linux";
    homepage = "https://gitee.com/openkylin/kylin-virtual-keyboard";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ dingdang66686 ];
    platforms = lib.platforms.linux;
  };
})
