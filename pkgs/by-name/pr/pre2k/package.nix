{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pre2k";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garrettfoster13";
    repo = "pre2k";
    tag = finalAttrs.version;
    hash = "sha256-z1ttuRos7x/zdWiYYozxWzRarFExd4W5rUYAEiUMugU=";
  };

  pythonRelaxDeps = [
    "impacket"
    "ldap3"
    "pyasn1"
    "rich"
    "typer"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    impacket
    ldap3
    pyasn1
    rich
    typer
  ];

  pythonImportsCheck = [ "pre2k" ];

  meta = {
    description = "Tool to query for the existence of pre-windows 2000 computer objects";
    homepage = "https://github.com/garrettfoster13/pre2k";
    changelog = "https://github.com/garrettfoster13/pre2k/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pre2k";
  };
})
