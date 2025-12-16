{
  lib,
  fetchFromGitHub,
  python3Packages,
  nginx,
}:

python3Packages.buildPythonApplication rec {
  pname = "gixy";
  version = "0.2.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvershinin";
    repo = "gixy";
    tag = "v${version}";
    hash = "sha256-kmsP5nKniMmXgc1O68IYGjOrVWqt0UK8cmw7cUfYYTU=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    crossplane
    configargparse
    jinja2
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  passthru = {
    inherit (nginx.passthru) tests;
  };

  meta = {
    changelog = "https://github.com/dvershinin/gixy/releases/tag/${src.tag}";
    description = "NGINX configuration static analyzer";
    longDescription = ''
      Gixy is a tool to analyze Nginx configuration.
      The main goal of Gixy is to prevent security misconfiguration and automate flaw detection.
    '';
    homepage = "https://github.com/dvershinin/gixy";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "gixy";
    platforms = lib.platforms.unix;
  };
}
