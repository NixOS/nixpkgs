{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "savepagenow";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pastpages";
    repo = "savepagenow";
    tag = version;
    sha256 = "sha256-omQ28GqgBKC8W51c0qb6Tg06obXskyfF+2dg/13ah1M=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    click
    requests
  ];

  # requires network access
  doCheck = false;

  pythonImportsCheck = [ "savepagenow" ];

  meta = with lib; {
    description = "Simple Python wrapper for archive.org's \"Save Page Now\" capturing service";
    homepage = "https://github.com/pastpages/savepagenow";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "savepagenow";
  };
}
