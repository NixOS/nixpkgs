{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "disposable-email-domains";
  version = "0.0.126";
  pyproject = true;

  # No tags on GitHub
  src = fetchPypi {
    pname = "disposable_email_domains";
    inherit version;
    hash = "sha256-fPxAOOT7yIT7DoupnUlC6iQQWBMw5iaNoH8hjjWBKMI=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "disposable_email_domains" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Set of disposable email domains";
    homepage = "https://github.com/disposable-email-domains/disposable-email-domains";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
