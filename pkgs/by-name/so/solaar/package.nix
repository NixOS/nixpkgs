{
  fetchFromGitHub,
  lib,
  gobject-introspection,
  gtk3,
  python3Packages,
  wrapGAppsHook3,
  gdk-pixbuf,
  libappindicator,
  librsvg,
  upower,
  udevCheckHook,
  acl,
}:

# Although we copy in the udev rules here, you probably just want to use
# `logitech-udev-rules`, which is an alias to `udev` output of this derivation,
# instead of adding this to `services.udev.packages` on NixOS,
python3Packages.buildPythonApplication rec {
  pname = "solaar";
  version = "1.1.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pwr-Solaar";
    repo = "Solaar";
    tag = version;
    hash = "sha256-PhZoDRsckJXk2t2qR8O3ZGGeMUhmliqSpibfQDO7BeA=";
  };

  outputs = [
    "out"
    "udev"
  ];

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
    udevCheckHook
  ];

  buildInputs = [
    libappindicator
    librsvg
    upower
  ];

  propagatedBuildInputs = with python3Packages; [
    evdev
    dbus-python
    gtk3
    hid-parser
    psutil
    pygobject3
    pyudev
    pyyaml
    typing-extensions
    xlib
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    pytest-cov-stub
  ];

  preConfigure = ''
    substituteInPlace lib/solaar/listener.py \
      --replace-fail /usr/bin/getfacl "${lib.getExe' acl "getfacl"}"
  '';

  # the -cli symlink is just to maintain compabilility with older versions where
  # there was a difference between the GUI and CLI versions.
  postInstall = ''
    ln -s $out/bin/solaar $out/bin/solaar-cli

    install -Dm444 -t $udev/etc/udev/rules.d rules.d-uinput/*.rules
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonImportsCheck = [
    "solaar"
    "solaar.gtk"
  ];

  meta = with lib; {
    description = "Linux devices manager for the Logitech Unifying Receiver";
    longDescription = ''
      Solaar is a Linux manager for many Logitech keyboards, mice, and trackpads that
      connect wirelessly to a USB Unifying, Lightspeed, or Nano receiver, connect
      directly via a USB cable, or connect via Bluetooth. Solaar does not work with
      peripherals from other companies.

      Solaar can be used as a GUI application or via its command-line interface.

      This tool requires either to be run with root/sudo or alternatively to have the udev rules files installed. On NixOS this can be achieved by setting `hardware.logitech.wireless.enable`.
    '';
    homepage = "https://pwr-solaar.github.io/Solaar/";
    license = licenses.gpl2Only;
    mainProgram = "solaar";
    maintainers = with maintainers; [
      spinus
      ysndr
      oxalica
    ];
    platforms = platforms.linux;
  };
}
