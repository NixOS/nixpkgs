{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clairvoyance";
<<<<<<< HEAD
  version = "2.5.5";
=======
  version = "2.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nikitastupin";
    repo = "clairvoyance";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-anUceLMTeHQ/Z0+MjKL0alDdKaWA5y3HpJC81MBTTq8=";
=======
    hash = "sha256-5PbvR0HVvA2xFzD+Jtisxuk68pdM29NyweFbZKBbhzs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "rich" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aiohttp
    rich
  ];

  nativeCheckInputs = with python3.pkgs; [
    aiounittest
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'asyncio = "^3.4.3"' ""
  '';

  pythonImportsCheck = [ "clairvoyance" ];

  disabledTests = [
    # KeyError
    "test_probe_typename"
  ];

  meta = {
    description = "Tool to obtain GraphQL API schemas";
    homepage = "https://github.com/nikitastupin/clairvoyance";
    changelog = "https://github.com/nikitastupin/clairvoyance/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "clairvoyance";
  };
}
