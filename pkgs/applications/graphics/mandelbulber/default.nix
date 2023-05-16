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
<<<<<<< HEAD
  version = "2.30";
=======
  version = "2.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "buddhi1980";
    repo = "mandelbulber2";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-xDW1Fk0GpjJQWE4ljbYXanp5N4wJYJUCRxKUCi7yJm0=";
=======
    sha256 = "sha256-PVyJnPPNehQ5qzhuoUsDRQ+V3azauEkIk26XfLZOmXg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    "SHARED_PATH=${placeholder "out"}"
    (if withOpenCL
      then "qmake/mandelbulber-opencl.pro"
      else "qmake/mandelbulber.pro")
  ];

  meta = with lib; {
    description = "A 3D fractal rendering engine";
    longDescription = "Mandelbulber creatively generates three-dimensional fractals. Explore trigonometric, hyper-complex, Mandelbox, IFS, and many other 3D fractals.";
    homepage = "https://mandelbulber.com";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kovirobi ];
  };
}
