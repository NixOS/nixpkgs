{
  lib,
  stdenv,
  awscli,
  fetchFromGitHub,
  installShellFiles,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nimbo";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nimbo-sh";
    repo = "nimbo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YC5T02Sw22Uczufbyts8l99oCQW4lPq0gPMRXCoKsvw=";
  };

  postPatch = ''
    # Wrong format specifier in awscli dependency
    substituteInPlace setup.py \
      --replace-fail "awscli>=1.19<2.0" "awscli>=1.19,<2.0"
  '';

  pythonRelaxDeps = [
    "awscli"
    "colorama"
    "rich"
  ];

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3.pkgs; [
    boto3
    click
    colorama
    pydantic
    pyyaml
    requests
    rich
    setuptools
  ];

  # nimbo tests require an AWS instance
  doCheck = false;

  pythonImportsCheck = [ "nimbo" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ awscli ])
  ];

  meta = {
    description = "Run machine learning jobs on AWS with a single command";
    homepage = "https://github.com/nimbo-sh/nimbo";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ noreferences ];
  };
})
