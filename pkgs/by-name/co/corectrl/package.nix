{
  botan3,
  extra-cmake-modules,
  fetchFromGitLab,
  hwdata,
  lib,
  libdrm,
  libsForQt5,
  mesa-demos,
  polkit,
  procps,
  pugixml,
  spdlog,
  stdenv,
  util-linux,
  vulkan-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corectrl";
  version = "1.4.3";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-rQibIjLmSnkA8jk6GOo68JIeb4wZq0wxXpLs3zsB7GI=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    botan3
    libdrm # TODO: report upstream that libdrm is not detected at configure time
    libsForQt5.karchive
    libsForQt5.kauth
    libsForQt5.qtbase
    libsForQt5.qtcharts
    libsForQt5.qtquickcontrols2
    libsForQt5.qtsvg
    libsForQt5.qttools
    libsForQt5.qtxmlpatterns
    libsForQt5.quazip
    mesa-demos
    polkit
    procps
    pugixml
    spdlog
    util-linux
    vulkan-tools
  ];

  patches = [
    ./polkit-dir.patch
  ];

  cmakeFlags = [
    "-DINSTALL_DBUS_FILES_IN_PREFIX=true"
    "-DPOLKIT_POLICY_INSTALL_DIR=${placeholder "out"}/share/polkit-1/actions"
    "-DWITH_PCI_IDS_PATH=${hwdata}/share/hwdata/pci.ids"
  ];

  runtimeInputs = [
    hwdata
    mesa-demos
    procps
    util-linux
    vulkan-tools
  ];

  qrWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs}"
  ];

  meta = {
    homepage = "https://gitlab.com/corectrl/corectrl/";
    description = "Control your computer hardware via application profiles";
    longDescription = ''
      CoreCtrl is a Free and Open Source GNU/Linux application that allows you
      to control with ease your computer hardware using application profiles. It
      aims to be flexible, comfortable and accessible to regular users.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
})
