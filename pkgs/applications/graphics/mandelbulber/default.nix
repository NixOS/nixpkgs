{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  writableTmpDirAsHomeHook,
  nix-update-script,
  libpng,
  gsl,
  libsndfile,
  lzo,
  libsForQt5,
  withOpenCL ? true,
  opencl-clhpp ? null,
  ocl-icd ? null,
}:

assert withOpenCL -> opencl-clhpp != null;
assert withOpenCL -> ocl-icd != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "mandelbulber";
  version = "2.33";

  src = fetchFromGitHub {
    owner = "buddhi1980";
    repo = "mandelbulber2";
    rev = finalAttrs.version;
    sha256 = "sha256-3PPgH9E+k2DFm8ib1bmvTsllQ9kYi3oLDwPHcs1Otac=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libpng
    gsl
    libsndfile
    lzo
  ]
  ++ lib.optionals withOpenCL [
    opencl-clhpp
    ocl-icd
  ];

  sourceRoot = "${finalAttrs.src.name}/mandelbulber2";

  qmakeFlags = [
    "SHARED_PATH=${placeholder "out"}"
    (if withOpenCL then "qmake/mandelbulber-opencl.pro" else "qmake/mandelbulber.pro")
  ];

  passthru = {
    tests = {
      test = runCommand "mandelbulber2-test" {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          writableTmpDirAsHomeHook
        ];
      } "mandelbulber2 --test && touch $out";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "3D fractal rendering engine";
    mainProgram = "mandelbulber2";
    longDescription = "Mandelbulber creatively generates three-dimensional fractals. Explore trigonometric, hyper-complex, Mandelbox, IFS, and many other 3D fractals.";
    homepage = "https://mandelbulber.com";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kovirobi ];
  };
})
