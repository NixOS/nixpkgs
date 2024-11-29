{
  lib,
  nix-update-script,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "oelint-adv";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-adv";
    rev = "refs/tags/${version}";
    hash = "sha256-bDttjeHcIK90W7zPrKNAS4B1L9mibaRjQdnUAU2N8as=";
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

  pythonRelaxDeps = [ "argcomplete" ];

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
    changelog = "https://github.com/priv-kweihmann/oelint-adv/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ otavio ];
  };
}
