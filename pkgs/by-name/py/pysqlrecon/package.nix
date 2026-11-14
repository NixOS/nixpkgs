{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pysqlrecon";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tw1sm";
    repo = "PySQLRecon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uHtSxgCBv6NolWqxyJidCUBwNrqOlDztR/hkbvy2TEY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build"
  '';

  pythonRelaxDeps = [
    "impacket"
    "rich"
    "typer"
  ];

  build-system = with python3.pkgs; [ uv-build ];

  dependencies = with python3.pkgs; [
    impacket
    pycryptodome
    rich
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysqlrecon" ];

  meta = {
    description = "Offensive MSSQL toolkit";
    homepage = "https://github.com/Tw1sm/PySQLRecon";
    changelog = "https://github.com/Tw1sm/PySQLRecon/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pysqlrecon";
  };
})
