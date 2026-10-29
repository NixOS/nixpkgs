{
  lib,
  stdenv,
  fetchFromGitLab,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "nemo-qml-plugin-dbus";
  version = "2.1.24";

  src = fetchFromGitLab {
    domain = "git.sailfishos.org";
    owner = "mer-core";
    repo = "nemo-qml-plugin-dbus";
    rev = version;
    hash = "sha256-51CgJk8NYB96L1C9iWLic5J4JslF9T07mKOZQpJIj8Y=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace dbus.pro --replace ' tests' ""
    substituteInPlace src/nemo-dbus/nemo-dbus.pro \
      --replace /usr $out \
      --replace '$$[QT_INSTALL_LIBS]' $out'/lib'
    substituteInPlace src/plugin/plugin.pro \
      --replace '$$[QT_INSTALL_QML]' $out'/${qt5.qtbase.qtQmlPrefix}'
  '';

  meta = {
    description = "Nemo DBus plugin for qml";
    homepage = "https://git.sailfishos.org/mer-core/nemo-qml-plugin-dbus/";
    license = lib.licenses.lgpl2Only;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux;
  };
}
