{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbcrawler";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SySS-Research";
    repo = "smbcrawler";
    tag = version;
    hash = "sha256-9hom/4wNCiBp70s0a3K4dq1BOcoVV+yAeiPQlvQ7yUw=";
  };

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    impacket
    lxml
    peewee
    python-libnmap
    python-magic
    pyyaml
    xdg-base-dirs
    zundler
  ];

  optional-dependencies = with python3.pkgs; {
    binary-conversion = [
      markitdown
    ];
  };

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "smbcrawler" ];

  disabledTests = [
    # Tests are container-based
    "test_base_guest_access"
    "test_full"
  ];

  meta = {
    description = "Tool that takes credentials and a list of hosts and crawls through shares";
    homepage = "https://github.com/SySS-Research/smbcrawler";
    changelog = "https://github.com/SySS-Research/smbcrawler/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smbcrawler";
  };
}
