{ lib
, mkDerivation
, fetchFromGitHub
, libpng
, gsl
, libsndfile
, lzo
, qmake
, qttools
, qtbase
, qtmultimedia
, withOpenCL ? true
, opencl-clhpp ? null
, ocl-icd ? null
}:

assert withOpenCL -> opencl-clhpp != null;
assert withOpenCL -> ocl-icd != null;

mkDerivation rec {
  pname = "mandelbulber";
  version = "2.20";

  src = fetchFromGitHub {
    owner = "buddhi1980";
    repo = "mandelbulber2";
    rev = version;
    sha256 = "043dks9fimhradyhdzqdc6lb9z0x9lkj3szj10751g424lppp207";
  };

  nativeBuildInputs = [
    qmake
    qttools
  ];
  buildInputs = [
    qtbase
    qtmultimedia
    libpng
    gsl
    libsndfile
    lzo
  ] ++ lib.optionals withOpenCL [
    opencl-clhpp
    ocl-icd
  ];

  sourceRoot = "${src.name}/mandelbulber2";

  qmakeFlags = [
    "SHARED_PATH=${placeholder ''out''}"
    (if withOpenCL
      then "qmake/mandelbulber-opencl.pro"
      else "qmake/mandelbulber.pro")
  ];

  meta = with lib; {
    description = "A 3D fractal rendering engine";
    longDescription = "Mandelbulber creatively generates three-dimensional fractals. Explore trigonometric, hyper-complex, Mandelbox, IFS, and many other 3D fractals.";
    homepage = "https://mandelbulber.com";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kovirobi ];
  };
}
