{ stdenv, fetchurl, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts
, hdf5, vtk, medfile, boost, zlib, python27Packages, swig, gfortran
, soqt, libf2c, makeWrapper, makeDesktopItem
, mpi ? null }:

assert mpi != null;

let
  pythonPackages = python27Packages;
in stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "0.17";

  src = fetchurl {
    url = "https://github.com/FreeCAD/FreeCAD/archive/${version}.tar.gz";
    sha256 = "1yv6abdzlpn4wxy315943xwrnbywxqfgkjib37qwfvbb8y9p60df";
  };

  buildInputs = with pythonPackages; [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt libf2c makeWrapper matplotlib mpi vtk hdf5 medfile
    pycollada pyside pysideShiboken pysideTools pivy
  ];

  enableParallelBuilding = true;

  # This should work on both x86_64, and i686 linux
  preBuild = ''
    export NIX_LDFLAGS="-L${gfortran.cc}/lib64 -L${gfortran.cc}/lib $NIX_LDFLAGS";
  '';

  # Their main() removes PYTHONPATH=, and we rely on it.
  preConfigure = ''
    sed '/putenv("PYTHONPATH/d' -i src/Main/MainGui.cpp
  '';

  postInstall = ''
    wrapProgram $out/bin/FreeCAD --prefix PYTHONPATH : $PYTHONPATH \
      --set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1

    mkdir -p $out/share/mime/packages
    cat << EOF > $out/share/mime/packages/freecad.xml
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
      <mime-type type="application/x-extension-fcstd">
        <sub-class-of type="application/zip"/>
        <comment>FreeCAD Document</comment>
        <glob pattern="*.fcstd"/>
      </mime-type>
    </mime-info>
    EOF

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/
    for entry in $out/share/applications/*.desktop; do
      substituteAllInPlace $entry
    done
  '';

  desktopItem = makeDesktopItem {
    name = "freecad";
    desktopName = "FreeCAD";
    genericName = "CAD Application";
    comment = meta.description;
    exec = "@out@/bin/FreeCAD %F";
    categories = "Science;Education;Engineering;";
    startupNotify = "true";
    mimeType = "application/x-extension-fcstd;";
    extraEntries = ''
      Path=@out@/share/freecad
    '';
  };

  meta = with stdenv.lib; {
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    homepage = https://www.freecadweb.org/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
