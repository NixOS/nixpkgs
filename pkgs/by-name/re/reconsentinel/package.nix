{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "reconsentinel";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serene-brew";
    repo = "ReconSentinel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yoO0T7+LS/8ORd0nda7FB+B+Kcm6senx58zYEr//8IU=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    dnspython
    jinja2
    pyyaml
    requests
    rich
    tldextract
    typer
  ];

  pythonImportsCheck = [ "recon_sentinel" ];

  # Project has no test
  doCheck = false;

  meta = {
    description = "Tools for reconnaissance and OSINT gathering";
    homepage = "https://github.com/serene-brew/ReconSentinel";
    changelog = "https://github.com/serene-brew/ReconSentinel/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "reconsentinel";
  };
})
