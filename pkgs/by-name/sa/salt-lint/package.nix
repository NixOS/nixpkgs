{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "salt-lint";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "warpnet";
    repo = "salt-lint";
    tag = "v${version}";
    hash = "sha256-Q/blaqDqs9gPrMfN+e1hkCi9IPMM0osPYTDsT6UODB4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pathspec
    pyyaml
  ];

  nativeInputChecks = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Command-line utility that checks for best practices in SaltStack";
    homepage = "https://salt-lint.readthedocs.io/en/latest/";
    license = licenses.mit;
    mainProgram = "salt-lint";
    maintainers = with maintainers; [ genga898 ];
  };
}
