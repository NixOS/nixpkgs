{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pylode";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = "pylode";
    tag = finalAttrs.version;
    hash = "sha256-X12rcXvFvMB5tZ3WtfCE+yb8mhed9FnscjiTmMcSyV4=";
  };

  pythonRelaxDeps = [ "rdflib" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    dominate
    html5lib
    httpx
    markdown
    rdflib
  ];

  # Path issues with the tests
  doCheck = false;

  pythonImportsCheck = [ "pylode" ];

  meta = {
    description = "OWL ontology documentation tool using Python and templating, based on LODE";
    homepage = "https://github.com/RDFLib/pyLODE";
    changelog = "https://github.com/RDFLib/pyLODE/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ koslambrou ];
    mainProgram = "pylode";
  };
})
