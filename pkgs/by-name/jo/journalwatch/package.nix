{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "journalwatch";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "The-Compiler";
    repo = "journalwatch";
    tag = "v${version}";
    hash = "sha512-60+ewzOIox2wsQFXMAgD7XN+zvPA1ScPz6V4MB5taVDhqCxUTMVOxodf+4AMhxtNQloXZ3ye7/0bjh1NPDjxQg==";
  };

  # can be removed post 1.1.0
  postPatch = ''
    substituteInPlace test_journalwatch.py \
      --replace-fail "U Thu Jan  1 00:00:00 1970 prio foo [1337]" "U Thu Jan  1 00:00:00 1970 pprio foo [1337]"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ systemd-python ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "journalwatch" ];

  meta = with lib; {
    description = "Tool to find error messages in the systemd journal";
    homepage = "https://github.com/The-Compiler/journalwatch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ florianjacob ];
    mainProgram = "journalwatch";
  };
}
