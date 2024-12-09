{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clairvoyance";
  version = "2.5.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nikitastupin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-CVXa2HvX7M0cwqnTeZVETg07j324ATQuMNreEgAC2QA=";
  };

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

  meta = with lib; {
    description = "Tool to obtain GraphQL API schemas";
    mainProgram = "clairvoyance";
    homepage = "https://github.com/nikitastupin/clairvoyance";
    changelog = "https://github.com/nikitastupin/clairvoyance/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
