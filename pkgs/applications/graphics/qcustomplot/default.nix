{ stdenv, lib, fetchurl, qt5, gcc, cmake, pkg-config }:
stdenv.mkDerivation rec {
  pname = "qcustomplot";
  version = "2.1.1";
  src = fetchurl {
    url = "https://www.qcustomplot.com/release/${version}/QCustomPlot-source.tar.gz";
    sha256 = "sha256:Xi0i3sd5248B81fL2yXlT7z5ca2u516ujXrSRESHGC8=";
  };
  patches = [ ./add-cmake.patch ];
  cmakeFlags = [ "-DUSE_QT_VERSION=5" ];
  nativeBuildInputs = [ cmake pkg-config ];
  dontWrapQtApps = true;
  buildInputs = [ qt5.qtbase ];
  meta = with lib; {
    homepage = "https://qtcustomplot.com/";
    description = "A Qt C++ widget for plotting and data visualization";
    license = licenses.gpl3;

    longDescription = ''
      QCustomPlot is a Qt C++ widget for plotting and data visualization.
      It has no further dependencies and is well documented. This plotting
      library focuses on making good looking, publication quality 2D plots,
      graphs and charts, as well as offering high performance for realtime
      visualization applications. QCustomPlot can export to various formats
      such as vectorized PDF files and rasterized images like PNG, JPG and BMP.
      QCustomPlot is the solution for displaying of realtime data inside the
      application as well as producing high quality plots for other media.
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ jake-arkinstall ];
  };

}
