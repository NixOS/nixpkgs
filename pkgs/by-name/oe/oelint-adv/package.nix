{
  lib,
  nix-update-script,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "oelint-adv";
  version = "6.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-adv";
    tag = version;
    hash = "sha256-rJ1M5YRXcKbDEGhy0G+N2dGD3sx8KFUfLJSLthYQNtU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    anytree
    argcomplete
    colorama
    oelint-parser
    urllib3
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytest-forked
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access
    "TestClassOelintVarsHomepagePing"
  ];

  pythonRelaxDeps = [
    "argcomplete"
    "urllib3"
  ];

  pythonImportsCheck = [ "oelint_adv" ];

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--random-order-bucket=global" "" \
      --replace-fail "--random-order"               "" \
      --replace-fail "--force-sugar"                "" \
      --replace-fail "--old-summary"                ""
  '';

  meta = with lib; {
    description = "Advanced bitbake-recipe linter";
    mainProgram = "oelint-adv";
    homepage = "https://github.com/priv-kweihmann/oelint-adv";
    changelog = "https://github.com/priv-kweihmann/oelint-adv/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ otavio ];
  };
}
