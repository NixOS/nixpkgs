{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "lswmi";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Wer-Wolf";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-zggtVh34SoNjSfNqMDrnyjiU0sUT6+6cdmfPaSbf7YQ=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = {
    description = "Utility to retrieve information about WMI devices on Linux";
    homepage = "https://github.com/Wer-Wolf/lswmi";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.synalice ];
    mainProgram = "lswmi";
  };
}
