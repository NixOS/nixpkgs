{ lib, stdenv, python27Packages, curaengine, makeDesktopItem, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cura";
  version = "15.06.03";

  src = fetchFromGitHub {
    owner = "daid";
    repo = "Cura";
    rev = version;
    sha256 = "sha256-o1cAi4Wi19WOijlRB9iYwNEpSNnmywUj5Bth8rRhqFA=";
  };

  desktopItem = makeDesktopItem {
    name = "Cura";
    exec = "cura";
    icon = "cura";
    comment = "Cura";
    desktopName = "Cura";
    genericName = "3D printing host software";
    categories = [ "GNOME" "GTK" "Utility" ];
  };

  python_deps = with python27Packages; [ pyopengl pyserial numpy wxPython30 power setuptools ];

  pythonPath = python_deps;

  propagatedBuildInputs = python_deps;

  buildInputs = [ curaengine python27Packages.wrapPython ];

  configurePhase = "";
  buildPhase = "";

  patches = [ ./numpy-cast.patch ];

  installPhase = ''
    # Install Python code.
    site_packages=$out/lib/python2.7/site-packages
    mkdir -p $site_packages
    cp -r Cura $site_packages/

    # Install resources.
    resources=$out/share/cura
    mkdir -p $resources
    cp -r resources/* $resources/
    sed -i 's|os.path.join(os.path.dirname(__file__), "../../resources")|"'$resources'"|g' $site_packages/Cura/util/resources.py

    # Install executable.
    mkdir -p $out/bin
    cp Cura/cura.py $out/bin/cura
    chmod +x $out/bin/cura
    sed -i 's|#!/usr/bin/python|#!/usr/bin/env python|' $out/bin/cura
    wrapPythonPrograms

    # Make it find CuraEngine.
    echo "def getEngineFilename(): return '${curaengine}/bin/CuraEngine'" >> $site_packages/Cura/util/sliceEngine.py

    # Install desktop item.
    mkdir -p "$out"/share/applications
    cp "$desktopItem"/share/applications/* "$out"/share/applications/
    mkdir -p "$out"/share/icons
    ln -s "$resources/images/c.png" "$out"/share/icons/cura.png
  '';

  meta = with lib; {
    description = "3D printing host software";
    homepage = "https://github.com/daid/Cura";
    license = licenses.agpl3;
    platforms = platforms.linux;
  };
}
