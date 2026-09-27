{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "hyuga";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sakuraiyuta";
    repo = "hyuga";
    tag = version;
    hash = "sha256-7TLWx+t9VE1LcjH3z0XGHSeR1kcYy2EjPmvI1fUoilM=";
  };

  postPatch = ''
    substituteInPlace hyuga/uri/helper.hy \
       --replace-fail "{root-path}/.venv/lib" "$out/lib"
  '';

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    hy
    hyrule
    toolz
    pygls
    setuptools # required for pkg_resources
  ];

  pythonRelaxDeps = [ "setuptools" ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  doCheck = true;

  meta = {
    description = "Yet Another Hy Language Server";
    mainProgram = "hyuga";
    license = lib.licenses.mit;
    homepage = "https://github.com/sakuraiyuta/hyuga";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
