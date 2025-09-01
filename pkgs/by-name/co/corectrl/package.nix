{
  botan3,
  fetchFromGitLab,
  cmake,
  pkg-config,
  hwdata,
  lib,
  libdrm,
  kdePackages,
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
  version = "1.5.1";

  src = fetchFromGitLab {
    owner = "corectrl";
    repo = "corectrl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NwGrvDqImiyPc3AsL7rMwNG9na+AzZS6NvXQOc6VWHg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    botan3
    libdrm # TODO: report upstream that libdrm is not detected at configure time
    kdePackages.karchive
    kdePackages.kauth
    kdePackages.qtbase
    kdePackages.qtcharts
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    mesa-demos
    polkit
    procps
    pugixml
    spdlog
    util-linux
    vulkan-tools
  ];

  patches = [
    ./Always-locate-polkit-with-pkg-config.diff
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

  qtWrapperArgs = [
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
