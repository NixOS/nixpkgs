{
  lib,
  fetchFromGitHub,
  python3Packages,
  btrfs-progs,
}:

python3Packages.buildPythonApplication rec {
  pname = "btrsync";
  version = "0.3";
  disable = python3Packages.pythonOlder "3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreittr";
    repo = "btrsync";
    tag = "v${version}";
    hash = "sha256-1LpHO70Yli9VG1UeqPZWM2qUMUbSbdgNP/r7FhUY/h4=";
  };

  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [ btrfs-progs ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = {
    description = "btrfs replication made easy";
    homepage = "https://github.com/andreittr/btrsync";
    changelog = "https://github.com/andreittr/btrsync/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "btrsync";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}
