{
  lib,
  python312Packages,
  nixosTests,
}:

let
  python3Packages = python312Packages;
in
python3Packages.buildPythonApplication rec {
  pname = "nipap-cli";
  inherit (python3Packages.nipap) version src;
  pyproject = true;

  sourceRoot = "${src.name}/nipap-cli";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'docutils==0.20.1' 'docutils'
  '';

  build-system = with python3Packages; [
    setuptools
    docutils
  ];

  dependencies = with python3Packages; [
    ipy
    pynipap
  ];

  checkInputs = with python3Packages; [
    pythonImportsCheckHook
  ];
  pythonImportsCheck = [
    "nipap_cli.nipap_cli"
  ];

  passthru.tests.nixos = nixosTests.nipap;

  meta = {
    description = "Neat IP Address Planner CLI";
    longDescription = ''
      NIPAP is the best open source IPAM in the known universe,
      challenging classical IP address management (IPAM) systems in many areas.
    '';
    homepage = "https://github.com/SpriteLink/NIPAP";
    changelog = "https://github.com/SpriteLink/NIPAP/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lukegb
    ];
    platforms = lib.platforms.all;
    mainProgram = "nipap";
  };
}
