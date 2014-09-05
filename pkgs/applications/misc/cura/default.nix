{ stdenv, python27Packages, curaengine, makeDesktopItem, fetchurl }:
let
    py = python27Packages;
    version = "14.07";
in
stdenv.mkDerivation rec {
  name = "cura";

  src = fetchurl {
    url = "https://github.com/daid/Cura/archive/${version}.tar.gz";
    sha256 = "1jfgkb2qh1syakcssk66yhnfjm9p9qcx48v34bbza9nryrdlmxdb";
  };

  desktopItem = makeDesktopItem {
    name = "Cura";
    exec = "cura";
    icon = "cura";
    comment = "Cura";
    desktopName = "Cura";
    genericName = "3D printing host software";
    categories = "GNOME;GTK;Utility;";
  };

  python_deps = [ py.pyopengl py.pyserial py.numpy py.wxPython30 py.power py.setuptools ];

  pythonPath = python_deps;

  propagatedBuildInputs = python_deps;

  buildInputs = [ curaengine py.wrapPython ];

  configurePhase = "";
  buildPhase = "";

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

  meta = with stdenv.lib; {
    description = "3D printing host software";
    homepage = https://github.com/daid/Cura;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
