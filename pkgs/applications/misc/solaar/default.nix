{fetchFromGitHub, stdenv, gtk3, pythonPackages, gobjectIntrospection}:
pythonPackages.buildPythonApplication rec {
  name = "solaar-unstable-${version}";
  version = "2018-02-02";
  namePrefix = "";
  src = fetchFromGitHub {
    owner = "pwr";
    repo = "Solaar";
    rev = "59b7285fdfc875119f0c92cfd5f5909e8a8e578c";
    sha256 = "0zy5vmjzdybnjf0mpp8rny11sc43gmm8172svsm9s51h7x0v83y3";
  };

  propagatedBuildInputs = [pythonPackages.pygobject3 pythonPackages.pyudev gobjectIntrospection gtk3];
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
    maintainers = [maintainers.spinus maintainers.ysndr];
  };
}
