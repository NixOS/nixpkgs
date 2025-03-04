{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "cc2538-bsl";
  version = "2.1-unstable-2025-01-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JelmerT";
    repo = "cc2538-bsl";
    rev = "bb6471103c2bddd319e5fda46fe4e872ce1de407";
    hash = "sha256-iVdwwZozoFsHpLMiZq3i9wldfusAsCCZy6isKfvGqKo=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev0+g${lib.substring 0 7 src.rev}";

  build-system = with python3Packages; [
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    intelhex
    pyserial
    python-magic
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    scripttest
  ];

  postInstall = ''
    # Remove .py from binary
    mv $out/bin/cc2538-bsl.py $out/bin/cc2538-bsl
  '';

  meta = with lib; {
    homepage = "https://github.com/JelmerT/cc2538-bsl";
    description = "Flash TI SimpleLink chips (CC2538, CC13xx, CC26xx) over serial";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lorenz ];
    mainProgram = "cc2538-bsl";
  };
}
