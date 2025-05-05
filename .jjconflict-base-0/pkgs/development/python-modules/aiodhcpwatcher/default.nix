{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  scapy,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiodhcpwatcher";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodhcpwatcher";
    rev = "v${version}";
    hash = "sha256-qdtOEfhBrLpO14IJNuTL71ajmf9sjgKgjuT/3Mqycc8=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [ scapy ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "aiodhcpwatcher" ];

  meta = with lib; {
    description = "Watch for DHCP packets with asyncio";
    homepage = "https://github.com/bdraco/aiodhcpwatcher";
    changelog = "https://github.com/bdraco/aiodhcpwatcher/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
