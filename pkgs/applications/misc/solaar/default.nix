{ fetchFromGitHub, lib, gobject-introspection, gtk3, python3Packages }:
# Although we copy in the udev rules here, you probably just want to use logitech-udev-rules instead of
# adding this to services.udev.packages on NixOS
python3Packages.buildPythonApplication rec {
  pname = "solaar";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "pwr-Solaar";
    repo = "Solaar";
    rev = "${version}";
    sha256 = "1ni3aimpl9vyhwzi61mvm8arkii52cmb6bzjma9cnkjyx328pkid";
  };

  propagatedBuildInputs = with python3Packages; [ gobject-introspection gtk3 pygobject3 pyudev ];

  postInstall = ''
    wrapProgram "$out/bin/solaar" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
    wrapProgram "$out/bin/solaar-cli" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

    install -Dm644 -t $out/etc/udev/rules.d rules.d/*.rules
  '';

  enableParallelBuilding = true;
  meta = with lib; {
    description = "Linux devices manager for the Logitech Unifying Receiver";
    longDescription = ''
      Solaar is a Linux device manager for Logitech’s Unifying Receiver
      peripherals. It is able to pair/unpair devices to the receiver, and for
      most devices read battery status.

      It comes in two flavors, command-line and GUI. Both are able to list the
      devices paired to a Unifying Receiver, show detailed info for each
      device, and also pair/unpair supported devices with the receiver.

      To be able to use it, make sure you have access to /dev/hidraw* files.
    '';
    license = licenses.gpl2;
    homepage = https://pwr-solaar.github.io/Solaar/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ spinus ysndr ];
  };
}
