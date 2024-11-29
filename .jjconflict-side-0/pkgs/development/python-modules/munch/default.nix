{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pbr,
  setuptools,

  # tests
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "munch";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Infinidat";
    repo = "munch";
    rev = "refs/tags/${version}";
    hash = "sha256-p7DvOGRhkCmtJ32EfttyKXGGmO5kfb2bQGqok/RJtU8=";
  };

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    description = "Dot-accessible dictionary (a la JavaScript objects)";
    license = licenses.mit;
    homepage = "https://github.com/Infinidat/munch";
  };
}
