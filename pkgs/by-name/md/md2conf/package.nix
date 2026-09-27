{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  nix-update-script,
  runCommand,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "md2conf";
  version = "0.6.1";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hunyadi";
    repo = "md2conf";
    tag = finalAttrs.version;
    hash = "sha256-DFGFDJYpadcRZ6gJ4yjYHS7d+oJtu4L/fwKIyJDNneA=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    cattrs
    lxml
    markdown
    orjson
    pymdown-extensions
    pyyaml
    requests
    truststore
    # "formulas" optional extra (matplotlib): available but omitted, to keep the closure lean
    # typing-extensions is conditional on Python < 3.11; default interpreter is 3.12
  ];

  # The "dev" extra (mypy, ruff, types-*) is omitted: development tooling, not runtime.

  pythonImportsCheck = [ "md2conf" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      help =
        runCommand "md2conf-help-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            md2conf --help > /dev/null
            touch $out
          '';
    };
  };

  meta = {
    description = "Publish Markdown files to Confluence wiki";
    homepage = "https://github.com/hunyadi/md2conf";
    changelog = "https://github.com/hunyadi/md2conf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
    mainProgram = "md2conf";
  };
})
