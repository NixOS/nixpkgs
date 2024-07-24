{ lib, stdenv
, fetchFromGitLab
, extra-cmake-modules
, botan3
, karchive
, kauth
, libdrm
, hwdata
, glxinfo
, polkit
, procps
, pugixml
, spdlog
, util-linux
, vulkan-tools
, qtbase
, qtcharts
, qtquickcontrols2
, qtsvg
, qttools
, qtxmlpatterns
, quazip
, wrapQtAppsHook
} :

stdenv.mkDerivation rec{
  pname = "corectrl";
  version = "1.4.1";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "v${version}";
    hash = "sha256-E2Dqe1IYXjFb/nShQX+ARZW/AWpNonRimb3yQ6/2CFw=";
  };
  patches = [
    ./polkit-dir.patch
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    wrapQtAppsHook
  ];
  buildInputs = [
    botan3
    karchive
    kauth
    libdrm
    glxinfo
    polkit
    procps
    pugixml
    spdlog
    util-linux
    vulkan-tools
    qtbase
    qtcharts
    qtquickcontrols2
    qtsvg
    qttools
    qtxmlpatterns
    quazip
  ];

  cmakeFlags = [
    "-DWITH_PCI_IDS_PATH=${hwdata}/share/hwdata/pci.ids"
    "-DINSTALL_DBUS_FILES_IN_PREFIX=true"
    "-DPOLKIT_POLICY_INSTALL_DIR=${placeholder "out"}/share/polkit-1/actions"
  ];

  runtimeDeps = [ hwdata glxinfo vulkan-tools util-linux procps ];
  binPath = lib.makeBinPath runtimeDeps;

  dontWrapQtApps = true;

  postInstall = ''
    wrapQtApp $out/bin/corectrl --prefix PATH ":" ${binPath}
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/corectrl/corectrl/";
    description = "Control your computer hardware via application profiles";
    longDescription = ''
      CoreCtrl is a Free and Open Source GNU/Linux application that allows you
      to control with ease your computer hardware using application profiles. It
      aims to be flexible, comfortable and accessible to regular users.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
# TODO: report upstream that libdrm is not detected at configure time
