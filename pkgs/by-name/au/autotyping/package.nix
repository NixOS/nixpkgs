{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "autotyping";
  version = "24.9.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "JelleZijlstra";
    repo = "autotyping";
    tag = finalAttrs.version;
    hash = "sha256-N1Wdj7GpWB6jCjP9Y7RIN7DmwzGAer9zQKABDAD0oeE=";
  };
  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];
  dependencies = with python3.pkgs; [
    libcst
    typing-extensions
  ];
  pythonImportsCheck = [
    "autotyping"
  ];
  meta = {
    description = "Automatically add simple type annotations to your code";
    homepage = "https://github.com/JelleZijlstra/autotyping";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwoffinden ];
    mainProgram = "autotyping";
  };
})
