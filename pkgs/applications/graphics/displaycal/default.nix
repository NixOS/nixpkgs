{buildPythonPackage, stdenv, fetchurl, pkgconfig
 , libXext, libXxf86vm, libX11, libXrandr, libXinerama, libXScrnSaver
 , argyllcms, wxPython, numpy
 }:
buildPythonPackage {
  name = "displaycal-3.5.0.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/project/dispcalgui/release/3.5.0.0/DisplayCAL-3.5.0.0.tar.gz;
    sha256 = "1j496sv8pbhby5hkkbp07k6bs3f7mb1l3dijmn2iga3kmix0fn5q";
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
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  preConfigure = ''
    mkdir dist
    cp {misc,dist}/DisplayCAL.appdata.xml
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
    homepage = https://displaycal.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
