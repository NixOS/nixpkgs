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
    hash = "sha256-FBOtUTvj0wX6YJ6i74Pi3QsbDR+UDs842ET8eT6CFtE=";
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
