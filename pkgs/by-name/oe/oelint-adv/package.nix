{
  lib,
  nix-update-script,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "oelint-adv";
  version = "8.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-adv";
    tag = version;
    hash = "sha256-W8W+hNgRVxBVkEDyKtFVx2mCyvbMA4CPjR1NrehClJs=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--random-order-bucket=global" "" \
      --replace-fail "--random-order"               "" \
      --replace-fail "--force-sugar"                "" \
      --replace-fail "--old-summary"                ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    anytree
    argcomplete
    colorama
    oelint-data
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

  meta = {
    description = "Advanced bitbake-recipe linter";
    mainProgram = "oelint-adv";
    homepage = "https://github.com/priv-kweihmann/oelint-adv";
    changelog = "https://github.com/priv-kweihmann/oelint-adv/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
