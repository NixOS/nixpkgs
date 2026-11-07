{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  idna,
  pytest-mock,
  pytestCheckHook,
  requests,
  requests-file,
  responses,
  setuptools,
  setuptools-scm,
  sybil,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "tldextract";
  version = "5.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "john-kurkowski";
    repo = "tldextract";
    tag = finalAttrs.version;
    hash = "sha256-n5lwh1A57gpdTRpXx3TJ9qZwEEHGSb3Nm7U3TOPDsk4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    filelock
    idna
    requests
    requests-file
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    responses
    sybil
    syrupy
  ];

  pythonImportsCheck = [ "tldextract" ];

  meta = {
    description = "Python module to accurately separate the TLD from the domain of an URL";
    longDescription = ''
      tldextract accurately separates the gTLD or ccTLD (generic or country code top-level domain)
      from the registered domain and subdomains of a URL.
    '';
    homepage = "https://github.com/john-kurkowski/tldextract";
    changelog = "https://github.com/john-kurkowski/tldextract/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tldextract";
  };
})
