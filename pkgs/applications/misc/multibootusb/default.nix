{ stdenv, python36Packages, fetchFromGitHub, libxcb, mtools, p7zip, parted, procps, utillinux, qt5 }:
python36Packages.buildPythonApplication rec {
  pname = "multibootusb";
  name = "${pname}-${version}";
  version = "9.2.0";

  buildInputs = [
    python36Packages.dbus-python
    python36Packages.pyqt5
    python36Packages.pytest-shutil
    python36Packages.python
    python36Packages.pyudev
    python36Packages.six
    libxcb
    mtools
    p7zip
    parted
    procps
    qt5.full
    utillinux
  ];

  src = fetchFromGitHub {
    owner = "mbusb";
    repo = pname;
    rev = "v${version}";

    sha256 = "0wlan0cp6c2i0nahixgpmkm0h4n518gj8rc515d579pqqp91p2h3";
  };

  # Skip the fixup stage where stuff is shrinked (can't shrink text files)
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    share="$out/share/${pname}"
    mkdir -p "$share"
    cp -r data "$share/data"
    cp -r scripts "$share/scripts"
    cp "${pname}" "$share/${pname}"

    mkdir "$out/bin"
    cat > "$out/bin/${pname}" <<EOF
      #!${stdenv.shell}
      cd "$share"
      export PYTHONPATH="$PYTHONPATH:$share"
      export PATH="$PATH:${parted}/bin:${procps}/bin"

      "${python36Packages.python}/bin/python" "${pname}"
    EOF
    chmod +x "$out/bin/${pname}"
  '';

  meta = with stdenv.lib; {
    description = "Multiboot USB creator for Linux live disks";
    homepage = http://multibootusb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
