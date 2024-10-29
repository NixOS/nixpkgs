{ lib, stdenv
, fetchFromGitLab
, extra-cmake-modules
, botan3
, libdrm
, hwdata
, mesa-demos
, polkit
, procps
, pugixml
, spdlog
, util-linux
, vulkan-tools
, libsForQt5
} :

stdenv.mkDerivation rec{
  pname = "corectrl";
  version = "1.4.2";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "v${version}";
    hash = "sha256-WOljOakh177om7tLlroFwWO4gYsarfTCeVXX6+dmZs4=";
  };
  patches = [
    ./polkit-dir.patch
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    botan3
    libsForQt5.karchive
    libsForQt5.kauth
    libdrm
    mesa-demos
    polkit
    procps
    pugixml
    spdlog
    util-linux
    vulkan-tools
    libsForQt5.qtbase
    libsForQt5.qtcharts
    libsForQt5.qtquickcontrols2
    libsForQt5.qtsvg
    libsForQt5.qttools
    libsForQt5.qtxmlpatterns
    libsForQt5.quazip
  ];

  cmakeFlags = [
    "-DWITH_PCI_IDS_PATH=${hwdata}/share/hwdata/pci.ids"
    "-DINSTALL_DBUS_FILES_IN_PREFIX=true"
    "-DPOLKIT_POLICY_INSTALL_DIR=${placeholder "out"}/share/polkit-1/actions"
  ];

  runtimeDeps = [ hwdata mesa-demos vulkan-tools util-linux procps ];
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
    maintainers = with maintainers; [ Scrumplex ];
  };
}
# TODO: report upstream that libdrm is not detected at configure time
