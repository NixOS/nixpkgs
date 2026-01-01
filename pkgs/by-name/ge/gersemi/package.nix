{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gersemi";
<<<<<<< HEAD
  version = "0.23.2";
=======
  version = "0.23.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "BlankSpruce";
    repo = "gersemi";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-sXgu3KscRi/3Myg/4jarMZ4W7/CaQTmyxxbcu8/0o6Y=";
=======
    hash = "sha256-mAScW+OLHSN5idHk/Kd909sOJDBUAe2Vi55kdhTtlzQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    appdirs
    colorama
    lark
    pyyaml
  ];

  meta = {
    description = "Formatter to make your CMake code the real treasure";
    homepage = "https://github.com/BlankSpruce/gersemi";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ xeals ];
    mainProgram = "gersemi";
  };
}
