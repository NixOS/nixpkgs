{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "breads-ad";
  version = "1.2.4-unstable-2024-05-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oppsec";
    repo = "breads";
    rev = "bdfc8b5f0357a34847767505ddc98734ca3b491f";
    hash = "sha256-U1q15D59N55qBf4NVOpe5RpQjlE1ye2TNNIZf2IZV3U=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    impacket
    ldap3
    rich
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool to evaluate Active Directory Security";
    homepage = "https://github.com/oppsec/breads";
    changelog = "https://github.com/oppsec/breads/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "breads-ad";
  };
}
