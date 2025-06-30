{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "advance-touch";
  version = "1.0.2";
  format = "setuptools";

  disabled = python3.pkgs.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tanrax";
    repo = "terminal-AdvancedNewFile";
    rev = "a6306bcb0ab4d4024d336ae803f9713499e098e4";
    sha256 = "sha256-c7vRUtlPuHQPMaVvK8u1esdLaExzl9RMZQs+CMLLkVY=";
  };

  dependencies = with python3.pkgs; [ click ];

  meta = {
    description = "Fast creation of files and directories, mimicking AdvancedNewFile (Vim plugin)";
    homepage = "https://github.com/tanrax/terminal-AdvancedNewFile";
    license = lib.licenses.mit;
    mainProgram = "ad";
    maintainers = with lib.maintainers; [ blemouzy ];
  };
}
