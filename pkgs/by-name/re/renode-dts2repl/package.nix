{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "renode-dts2repl";
<<<<<<< HEAD
  version = "0-unstable-2025-12-18";
=======
  version = "0-unstable-2025-11-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "dts2repl";
<<<<<<< HEAD
    rev = "927f689d40c34fbe64f246abf9e6abf2d79f2fb5";
    hash = "sha256-cR/rMXGOLNyQDJSg77AI8+sco446sQNI/4IuuWHLDhE=";
=======
    rev = "a4e216d0bef24c92674913f261197d17292def5c";
    hash = "sha256-hgdT7mQ7ociy518WK0Z6s6LfUluwWH8SDJhhfjdz29g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [ "dts2repl" ];

  passthru.updateScript = unstableGitUpdater { };

<<<<<<< HEAD
  meta = {
    description = "Tool for converting device tree sources into Renode's .repl files";
    homepage = "https://github.com/antmicro/dts2repl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
=======
  meta = with lib; {
    description = "Tool for converting device tree sources into Renode's .repl files";
    homepage = "https://github.com/antmicro/dts2repl";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "dts2repl";
  };
}
