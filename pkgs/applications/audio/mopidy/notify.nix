{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-notify";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phijor";
    repo = "mopidy-notify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oAOJvonDDmtpmzgu8Y+BczuLYpfrVlwASIFOW7rhZ94=";
  };

  # Mopidy 4 exposes CoreListener from mopidy.core instead of mopidy.core.listener.
  # Remove when upstream supports Mopidy 4.
  postPatch = ''
    substituteInPlace mopidy_notify/frontend.py \
      --replace-fail 'from mopidy.core.listener import CoreListener' 'from mopidy.core import CoreListener'
  '';

  build-system = [
    pythonPackages.setuptools
  ];

  pythonRelaxDeps = [ "pykka" ];

  dependencies = [
    mopidy
    pythonPackages.pydbus
    pythonPackages.requests
  ];

  nativeBuildInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_notify" ];

  meta = {
    homepage = "https://github.com/phijor/mopidy-notify";
    description = "Mopidy extension for showing desktop notifications on track change";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
