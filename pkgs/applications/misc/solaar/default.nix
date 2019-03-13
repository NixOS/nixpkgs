{fetchFromGitHub, stdenv, gtk3, pythonPackages, gobject-introspection}:
pythonPackages.buildPythonApplication rec {
  pname = "solaar-unstable";
  version = "2019-01-30";

  src = fetchFromGitHub {
    owner = "pwr";
    repo = "Solaar";
    rev = "c07c115ee379e82db84283aaa29dc53df033a8c8";
    sha256 = "0xg181xcwzzs8pdqvjrkjyaaga7ir93hzjvd17j9g3ns8xfj2mvr";
  };

  propagatedBuildInputs = [pythonPackages.pygobject3 pythonPackages.pyudev gobject-introspection gtk3];
  postInstall = ''
    wrapProgram "$out/bin/solaar" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
    wrapProgram "$out/bin/solaar-cli" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

    mkdir -p $out/lib/udev/rules.d
    cp rules.d/*.rules $out/lib/udev/rules.d/
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
