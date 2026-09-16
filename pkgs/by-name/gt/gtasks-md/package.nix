{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gtasks-md";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "gtasks-md";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nocNA+dF4dSn70OfoBjP+utwfBiNfnSrMARaqCl2fuw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
    markdown-it-py
    mdformat
    xdg
  ];

  nativeCheckInputs = with python3Packages; [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "gtasks_md" ];

  meta = {
    description = "Manage Google Tasks using a Markdown document";
    homepage = "https://github.com/google/gtasks-md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jupblb ];
    mainProgram = "gtasks-md";
  };
})
