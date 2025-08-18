{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clairvoyance";
  version = "2.5.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nikitastupin";
    repo = "clairvoyance";
    tag = "v${version}";
    hash = "sha256-5PbvR0HVvA2xFzD+Jtisxuk68pdM29NyweFbZKBbhzs=";
  };

  pythonRelaxDeps = [ "rich" ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  pythonImportsCheck = [
    "clairvoyance"
  ];

  disabledTests = [
    # KeyError
    "test_probe_typename"
  ];

  meta = {
    description = "Tool to obtain GraphQL API schemas";
    mainProgram = "clairvoyance";
    homepage = "https://github.com/nikitastupin/clairvoyance";
    changelog = "https://github.com/nikitastupin/clairvoyance/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
