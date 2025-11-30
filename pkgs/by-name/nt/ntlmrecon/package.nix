{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ntlmrecon";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwnfoo";
    repo = "NTLMRecon";
    tag = "v-${version}";
    sha256 = "0rrx49li2l9xlcax84qxjf60nbzp3fgq77c36yqmsp0pc9i89ah6";
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
    changelog = "https://github.com/pwnfoo/NTLMRecon/releases/tag/v-${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
