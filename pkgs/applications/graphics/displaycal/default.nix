{ python2
, stdenv
, fetchurl
, pkgconfig
, libXext
, libXxf86vm
, libX11
, libXrandr
, libXinerama
, libXScrnSaver
, argyllcms
 }:

let
  inherit (python2.pkgs) buildPythonApplication wxPython numpy dbus-python;
in buildPythonApplication rec {
  pname = "displaycal";
  version = "3.8.9.3";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/project/dispcalgui/release/${version}/DisplayCAL-${version}.tar.gz";
    sha256 = "1sivi4q7sqsrc95qg5gh37bsm2761md4mpl89hflzwk6kyyxyd3w";
  };

  propagatedBuildInputs = [
    libXext
    libXxf86vm
    libX11
    libXrandr
    libXinerama
    libXScrnSaver
    argyllcms
    wxPython
    numpy
    dbus-python
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  preConfigure = ''
    mkdir dist
    cp {misc,dist}/net.displaycal.DisplayCAL.appdata.xml
    touch dist/copyright
    mkdir -p $out
    ln -s $out/share/DisplayCAL $out/Resources
  '';

  # no idea why it looks there - symlink .json lang (everything)
  postInstall = ''
    for x in $out/share/DisplayCAL/*; do
      ln -s $x $out/lib/python2.7/site-packages/DisplayCAL
    done

    for prog in "$out/bin/"*; do
      wrapProgram "$prog" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix PATH : ${argyllcms}/bin
    done
  '';

  meta = {
    description = "Display Calibration and Characterization powered by Argyll CMS";
    homepage = "https://displaycal.net/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
