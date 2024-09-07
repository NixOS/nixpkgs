{ lib
, fetchFromBitbucket
, buildPythonApplication
, pyqt5
, matplotlib
, numpy
, cycler
, python-dateutil
, kiwisolver
, six
, setuptools
, dill
, rtree
, pyopengl
, vispy
, ortools
, svg-path
, simplejson
, shapely
, freetype-py
, fonttools
, rasterio
, lxml
, ezdxf
, qrcode
, reportlab
, svglib
, gdal
, pyserial
, python3
}:

buildPythonApplication rec {
  pname = "flatcam";
  version = "unstable-2022-02-02";

  src = fetchFromBitbucket {
    owner = "jpcgt";
    repo = pname;
    rev = "ebf5cb9e3094362c4b0774a54cf119559c02211d"; # beta branch as of 2022-02-02
    hash = "sha256-QKkBPEM+HVYmSZ83b4JRmOmCMp7C3EUqbJKPqUXMiKE=";
  };

  format = "other";

  dontBuild = true;

  propagatedBuildInputs = [
    pyqt5
    matplotlib
    numpy
    cycler
    python-dateutil
    kiwisolver
    six
    setuptools
    dill
    rtree
    pyopengl
    vispy
    ortools
    svg-path
    simplejson
    shapely
    freetype-py
    fonttools
    rasterio
    lxml
    ezdxf
    qrcode
    reportlab
    svglib
    gdal
    pyserial
  ];

  preInstall = ''
    patchShebangs .

    sed -i "s|/usr/local/bin|$out/bin|" Makefile

    mkdir -p $out/share/{flatcam,applications}
    mkdir -p $out/bin
  '';

  installFlags = [
    "USER_ID=0"
    "LOCAL_PATH=/build/source/."
    "INSTALL_PATH=${placeholder "out"}/share/flatcam"
    "APPS_PATH=${placeholder "out"}/share/applications"
  ];

  postInstall = ''
    sed -i "s|python3|${python3.withPackages (_: propagatedBuildInputs)}/bin/python3|" $out/bin/flatcam-beta
    mv $out/bin/flatcam{-beta,}
  '';

  meta = with lib; {
    description = "2-D post processing for PCB fabrication on CNC routers";
    homepage = "https://bitbucket.org/jpcgt/flatcam";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
