{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "edir";
  version = "2.32";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E9zb7Y4KNQ/gw+TkpRVMUHMPlY1ImQAb0P8G/OFgMwM=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    platformdirs
  ];

<<<<<<< HEAD
  meta = {
    description = "Program to rename and remove files and directories using your editor";
    homepage = "https://github.com/bulletmark/edir";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ guyonvarch ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Program to rename and remove files and directories using your editor";
    homepage = "https://github.com/bulletmark/edir";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ guyonvarch ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "edir";
  };
}
