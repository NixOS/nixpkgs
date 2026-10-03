{
  lib,
  fetchFromGitHub,
  python3,
  imagemagick,
}:

with python3.pkgs;

buildPythonApplication (finalAttrs: {
  pname = "noteshrink";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mzucker";
    repo = "noteshrink";
    rev = finalAttrs.version;
    hash = "sha256-ajLGs6ioEBv32rXJ/ua2HyUvGrvXZf3jWtY51MbbGXY=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    imagemagick
    pillow
  ];

  meta = {
    description = "Convert scans of handwritten notes to beautiful, compact PDFs";
    homepage = "https://mzucker.github.io/2016/09/20/noteshrink.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    mainProgram = "noteshrink";
  };
})
