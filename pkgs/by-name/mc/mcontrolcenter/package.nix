{
  lib,
  stdenv,
  libsForQt5,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  cmake,
  kmod,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcontrolcenter";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "dmitry-s93";
    repo = "MControlCenter";
    rev = finalAttrs.version;
    hash = "sha256-SV78OVRGzy2zFLT3xqeUtbjlh81Z97PVao18P3h/8dI=";
  };

  postPatch = ''
    substituteInPlace src/helper/helper.cpp \
      --replace-fail "/usr/sbin/modprobe" "${kmod}/bin/modprobe"
    substituteInPlace src/helper/mcontrolcenter.helper.service \
      --replace-fail "/usr" "$out"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "MControlCenter";
      exec = "mcontrolcenter";
      icon = "mcontrolcenter";
      comment = finalAttrs.meta.description;
      desktopName = "MControlCenter";
      categories = [ "System" ];
    })
  ];

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
    copyDesktopItems
    cmake
  ];

  buildInputs = [
    libsForQt5.qtbase
    kmod
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 mcontrolcenter $out/bin/mcontrolcenter
    install -Dm755 helper/mcontrolcenter-helper $out/libexec/mcontrolcenter-helper
    install -Dm644 ../resources/mcontrolcenter.svg $out/share/icons/hicolor/scalable/apps/mcontrolcenter.svg
    install -Dm644 ../src/helper/mcontrolcenter-helper.conf $out/share/dbus-1/system.d/mcontrolcenter-helper.conf
    install -Dm644 ../src/helper/mcontrolcenter.helper.service $out/share/dbus-1/system-services/mcontrolcenter.helper.service
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dmitry-s93/MControlCenter";
    description = "Tool to change the settings of MSI laptops running Linux";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.Tommimon ];
    mainProgram = "mcontrolcenter";
  };
})
