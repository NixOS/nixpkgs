{ stdenv, lib, fetchurl, python, pythonPackages, unzip }:

# This package uses a precompiled "binary" distribution of CuraByDagoma,
# distributed by the editor.
#
# To update the package, follow the links on https://dist.dagoma.fr/:
# * Cura By Dagoma
# * Linux
# * 64 bits
# * Genric archive
#
# I made the arbitrary choice to compile this package only for x86_64.
# I guess people owning a 3D printer generally don't use i686.
# If, however, someone needs it, we certainly can find a solution.

stdenv.mkDerivation rec {
  name = "curabydagoma-${version}";
  # Version is the date, UNIX format
  version = "1520506579";
  # Hash of the user's choice: os, arch, package type...
  hash = "58228cce5bbdcf764b7116850956f1e5";

  src = fetchurl {
    url = "https://dist.dagoma.fr/get/zip/CuraByDagoma/${version}/${hash}";
    sha256 = "16wfipdyjkf6dq8awjzs4zgkmqk6230277mf3iz8swday9hns8pq";
  };
  unpackCmd = "unzip $curSrc && tar zxf CuraByDagoma_amd64.tar.gz";
  nativeBuildInputs = [ unzip ];
  buildInputs = [ python pythonPackages.pyopengl pythonPackages.wxPython pythonPackages.pyserial pythonPackages.numpy ];

  # Compile all pyc files because the included pyc files may be older than the
  # py files. However, Python doesn't realize that because the packages
  # have all dates set to epoch.
  buildPhase = ''
    python -m compileall -f curabydago
  '';

  # * Simply copy the stuff there
  # * Create an executable with the correct path etc
  # * Create a .desktop file to have a launcher in the desktop environments
  installPhase = ''
    mkdir $out
    cp -r * $out/

    mkdir $out/bin
    cat > $out/bin/curabydago <<EOF
    #!/bin/sh
    export PYTHONPATH=$PYTHONPATH
    ${python.out}/bin/python $out/curabydago/cura.py
    EOF
    chmod a+x $out/bin/curabydago

    mkdir -p $out/share/applications
    cat > $out/share/applications/curabydago.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=Cura-by-dagoma
    Comment=CuraByDagoma is a fork of Legacy Cura made by Dagoma for its own printers.
    Icon=$out/curabydago/resources/images/cura.ico
    Exec=$out/bin/curabydago
    Path=$out/
    StartupNotify=true
    Terminal=false
    Categories=GNOME;GTK;Utility;
    EOF

  '';

  meta = with lib; {
    description = "Slicer for 3D printers built by Dagoma";
    homepage = https://dagoma.fr/cura-by-dagoma.html;
    license = licenses.agpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tiramiseb ];
  };
}
