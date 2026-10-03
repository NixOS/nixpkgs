{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ntlmrecon";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwnfoo";
    repo = "NTLMRecon";
    tag = "v-${finalAttrs.version}";
    hash = "sha256-BqqEYmIXXF2xN4Odg58b9y8LjJMdE9QVoz1REWkiPWc=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    colorama
    iptools
    requests
    termcolor
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ntlmrecon"
  ];

  meta = {
    description = "Information enumerator for NTLM authentication enabled web endpoints";
    mainProgram = "ntlmrecon";
    homepage = "https://github.com/pwnfoo/NTLMRecon";
    changelog = "https://github.com/pwnfoo/NTLMRecon/releases/tag/v-${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
