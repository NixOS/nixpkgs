{ fetchFromGitHub, lib, gobject-introspection, gtk3, python3Packages }:

# Although we copy in the udev rules here, you probably just want to use
# logitech-udev-rules instead of adding this to services.udev.packages on NixOS
python3Packages.buildPythonApplication rec {
  pname = "solaar";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "pwr-Solaar";
    repo = "Solaar";
    rev = version;
    sha256 = "sha256-k87DqIkvy5CVEsHT82ZArSM2JBi5sYdSCPfP4KjI850=";
  };

  propagatedBuildInputs = with python3Packages; [
    gobject-introspection
    gtk3
    psutil
    pygobject3
    pyudev
    pyyaml
    xlib
  ];

  makeWrapperArgs = [
    "--prefix PYTHONPATH : $PYTHONPATH"
    "--prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH"
  ];

  # the -cli symlink is just to maintain compabilility with older versions where
  # there was a difference between the GUI and CLI versions.
  postInstall = ''
    ln -s $out/bin/solaar $out/bin/solaar-cli

    install -Dm444 -t $out/etc/udev/rules.d rules.d/*.rules
  '';

  # No tests
  doCheck = false;

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
    maintainers = with maintainers; [ spinus ysndr ];
    platforms = platforms.linux;
  };
}
