{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fcitx5,
  libsForQt5,
  gsettings-qt,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "kylin-virtual-keyboard";
  version = "4.20.1.0";

  src = fetchFromGitHub {
    owner = "openkylin";
    repo = "kylin-virtual-keyboard";
    rev = "upstream/${version}";
    sha256 = "sha256-YM5FLJcgjhx7Ks1bgC26Ee4oDF8C6dK8yTtXSnD84aA=";
  };

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

    substituteInPlace data/kylin-virtual-keyboard-xwayland \
      --replace-fail "/usr" "${placeholder "out"}"

    substituteInPlace data/kylin-virtual-keyboard.desktop \
      --replace-fail "/usr" "${placeholder "out"}"

    substituteInPlace data/org.fcitx.Fcitx5.VirtualKeyboard.service \
      --replace-fail "/usr" "${placeholder "out"}"
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    wrapProgram $out/bin/$pname \
      --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/$pname-$version"
  '';

  meta = with lib; {
    description = "Kylin Virtual Keyboard - a modern on-screen keyboard for Linux";
    homepage = "https://gitee.com/openkylin/kylin-virtual-keyboard";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dingdang66686 ];
    platforms = platforms.linux;
  };
}
