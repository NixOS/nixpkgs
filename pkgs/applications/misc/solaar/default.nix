{fetchurl, stdenv, gtk3, python34Packages, gobjectIntrospection}:
python34Packages.buildPythonApplication rec {
  name = "solaar-${version}";
  version = "0.9.2";
  namePrefix = "";
  src = fetchurl {
    sha256 = "0954grz2adggfzcj4df4mpr4d7qyl7w8rb4j2s0f9ymawl92i05j";
    url = "https://github.com/pwr/Solaar/archive/${version}.tar.gz";
  };

  propagatedBuildInputs = [python34Packages.pygobject3 python34Packages.pyudev gobjectIntrospection gtk3];
  postInstall = ''
    wrapProgram "$out/bin/solaar" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
    wrapProgram "$out/bin/solaar-cli" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
  '';

  enableParallelBuilding = true;
  meta = with stdenv.lib; {
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
    homepage = https://pwr.github.io/Solaar/;
    platforms = platforms.linux;
    maintainers = [maintainers.spinus];
  };
}
