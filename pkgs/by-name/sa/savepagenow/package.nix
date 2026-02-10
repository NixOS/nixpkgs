{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "savepagenow";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pastpages";
    repo = "savepagenow";
    tag = finalAttrs.version;
    sha256 = "sha256-ztM1g71g8SN1LTyFF7sxaLhC3+nVsC9fJwfYPjkUsdE=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    click
    requests
  ];

  # requires network access
  doCheck = false;

  pythonImportsCheck = [ "savepagenow" ];

  meta = {
    description = "Simple Python wrapper for archive.org's \"Save Page Now\" capturing service";
    homepage = "https://github.com/pastpages/savepagenow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "savepagenow";
  };
})
