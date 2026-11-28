{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sploitscan";
  version = "0.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xaitax";
    repo = "SploitScan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n7KQ0I3eTIbXGP2uLix7lG4IAzlAShsFzlBoaQduoC4=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    gitpython
    google-genai
    jinja2
    openai
    requests
    tqdm
  ];

  pythonImportsCheck = [ "sploitscan" ];

  meta = {
    description = "Cybersecurity utility designed to provide detailed information on vulnerabilities and associated exploits";
    homepage = "https://github.com/xaitax/SploitScan";
    changelog = "https://github.com/xaitax/SploitScan/releases/tag/v.${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sploitscan";
  };
})
