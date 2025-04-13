{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.2.1";
in
python3Packages.buildPythonApplication {
  pname = "letsdns";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LetsDNS";
    repo = "letsdns";
    tag = version;
    hash = "sha256-TwGVm7sEOPvUqtvaAuIU/X5W3H4VAC8dskNunt8UO0I=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  dependencies = with python3Packages; [
    cryptography
    dnspython
    requests
  ];

  disabledTestPaths = [
    # These tests require upstream certificates
    "tests/test_action.py"
  ];

  env = {
    UNITTEST_CONF = "tests/citest.conf";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage DANE TLSA records in DNS servers";
    homepage = "https://www.letsdns.de/";
    downloadPage = "https://github.com/LetsDNS/letsdns";
    changelog = "https://github.com/LetsDNS/letsdns/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rseichter ];
    mainProgram = "letsdns";
  };
}
