{ lib, stdenv
, fetchFromGitLab
, extra-cmake-modules
, botan2
, karchive
, kauth
, libdrm
, hwdata
, glxinfo
, polkit
, procps
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
  version = "1.3.8";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "v${version}";
    sha256 = "sha256-lc6yWzJiSzGKMzJIpgOtirJONsh49vXWDWrhLV/erwQ=";
  };
  patches = [
    ./polkit-dir.patch
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    wrapQtAppsHook
  ];
  buildInputs = [
    botan2
    karchive
    kauth
    libdrm
    glxinfo
    polkit
    procps
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
