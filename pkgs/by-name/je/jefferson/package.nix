{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jefferson";
  version = "0.4.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PGtrvZ0cQvdiswn2Bk43c3LbIZqJyvNe5rnTPw/ipUM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    cstruct
    lzallright
  ];

  pythonImportsCheck = [
    "jefferson"
  ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "JFFS2 filesystem extraction tool";
    homepage = "https://github.com/onekey-sec/jefferson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tnias
      vlaci
    ];
    mainProgram = "jefferson";
  };
}
