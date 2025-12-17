{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ospd-openvas";
  version = "22.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "ospd-openvas";
    tag = "v${version}";
    hash = "sha256-4Lu9HVLxROEBDzkHgm4iH778QFwaLkM6qiOEq8OTcIU=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "lxml"
    "packaging"
    "psutil"
    "python-gnupg"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    deprecated
    lxml
    packaging
    paho-mqtt
    psutil
    python-gnupg
    redis
    sentry-sdk
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "ospd_openvas" ];

  meta = {
    description = "OSP server implementation to allow GVM to remotely control an OpenVAS Scanner";
    homepage = "https://github.com/greenbone/ospd-openvas";
    changelog = "https://github.com/greenbone/ospd-openvas/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
