{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gtk4,
  gobject-introspection,
  libappindicator,
  librsvg,
  bluez,
  linuxHeaders,
  libx11,
  libxext,
  libxfixes,
  libusb1,
  udev,
  udevCheckHook,
  gtk4-layer-shell,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sc-controller";
  version = "1.0.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "C0rn3j";
    repo = "sc-controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZrKimU9Dc3rdQ4EW+SzSu3PD+kybmXg2MBeRdASdo1w=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
    udevCheckHook
  ];

  buildInputs = [
    gtk4
    libappindicator
    librsvg
  ];

  dependencies =
    with python3Packages;
    [
      evdev
      pygobject3
      pylibacl
      vdf
      ioctl-opt
    ]
    ++ [
      gtk4-layer-shell
      python3Packages.libusb1
    ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.libusb1
    python3Packages.toml
  ];

  postPatch = ''
    substituteInPlace scc/paths.py --replace sys.prefix "'$out'"
    substituteInPlace scc/uinput.py --replace /usr/include ${linuxHeaders}/include
    substituteInPlace scc/device_monitor.py --replace "find_library('bluetooth')" "'libbluetooth.so.3'"
    substituteInPlace scc/gui/app.py --replace /lib /run/current-system/kernel-modules/lib
    substituteInPlace scc/version.py --replace 0.0.0+unknown ${finalAttrs.version}
  '';

  env.LD_LIBRARY_PATH = lib.makeLibraryPath [
    libx11
    libxext
    libxfixes
    libusb1
    udev
    bluez
    gtk4-layer-shell
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH")
  '';

  postFixup = ''
    (
      # scc runs these scripts as programs. (See find_binary() in scc/tools.py.)
      cd $out/lib/python*/site-packages/scc/x11
      patchPythonScript scc-autoswitch-daemon.py
      patchPythonScript scc-osd-daemon.py
    )
  '';

  preCheck = ''
    # Fix for tests not finding native libraries
    ln -s build/lib.*/*.so -t .
  '';

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/C0rn3j/sc-controller";
    # donations: https://www.patreon.com/kozec
    description = "User-mode driver and GUI for Steam Controller and other controllers";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rnhmjoj
    ];
  };
})
