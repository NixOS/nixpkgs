{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "matrix-dl";
  version = "0-unstable-2020-07-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rubo77";
    repo = "matrix-dl";
    rev = "b1a86d1421f39ee327284e1023f09dc165e3c8a5";
    sha256 = "1l8nh8z7kz24v0wcy3ll3w6in2yxwa1yz8lyc3x0blz37d8ss4ql";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    matrix-client
  ];

  meta = {
    description = "Download backlogs from Matrix as raw text";
    mainProgram = "matrix-dl";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.gpl1Plus;
    maintainers = with lib.maintainers; [ aw ];
    platforms = lib.platforms.unix;
  };
})
