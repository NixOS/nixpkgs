{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "facedetect";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "wavexx";
    repo = "facedetect";
    rev = "v${version}";
    hash = "sha256-TReDhgFXhk/iQus1n4YfwXQRmzWARCr3fVYvycKBrVU=";
  };

  patches = [
    (fetchpatch {
      name = "python3-support.patch";
      url = "https://gitlab.com/wavexx/facedetect/-/commit/8037d4406eb76dd5c106819f72c3562f8b255b5b.patch";
      sha256 = "1752k37pbkigiwglx99ba9360ahzzrrb65a8d77k3xs4c3bcmk2p";
    })
  ];

  buildInputs = [
    python3Packages.python
    python3Packages.wrapPython
  ];
  pythonPath = [
    python3Packages.numpy
    python3Packages.opencv4
  ];

  dontConfigure = true;

  postPatch = ''
    substituteInPlace facedetect \
      --replace /usr/share/opencv "${python3Packages.opencv4}/share/opencv4"
  '';

  installPhase = ''
    install -v -m644 -D README.rst $out/share/doc/${pname}-${version}/README.rst
    install -v -m755 -D facedetect $out/bin/facedetect
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://www.thregr.org/~wavexx/software/facedetect/";
    description = "Simple face detector for batch processing";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
    mainProgram = "facedetect";
  };
}
