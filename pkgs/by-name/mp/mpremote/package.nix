{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "mpremote";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    tag = "v${version}";
    hash = "sha256-Hk/DHMb9U/mLLVRKe+K3u5snxzW5BW3+bYRPFEAmUBQ=";
  };
  sourceRoot = "${src.name}/tools/mpremote";
  format = "pyproject";

  nativeBuildInputs = with python3Packages; [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];
  dependencies = with python3Packages; [
    pyserial
    importlib-metadata
  ];

  pythonImportsCheck = [ "mpremote" ];

  meta = {
    description = "Integrated set of utilities to remotely interact with and automate a MicroPython device over a serial connection";
    homepage = "https://github.com/micropython/micropython/blob/master/tools/mpremote/README.md";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _999eagle ];
    mainProgram = "mpremote";
  };
}
