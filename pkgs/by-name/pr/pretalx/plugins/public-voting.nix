{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-public-voting";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-public-voting";
    rev = "v${version}";
    hash = "sha256-1zxJ1b2CHfV2AVAneUJxurZ0L3QoMzuBf8c2wrj7yBA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_public_voting" ];

  meta = {
    description = "Public voting plugin for pretalx";
    homepage = "https://github.com/pretalx/pretalx-public-voting";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
