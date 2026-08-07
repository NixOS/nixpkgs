{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "evdevremapkeys";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "evdevremapkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gtml52tHNtg/3Fy+QO9eIh90nim0p0Fs+oEyqJvsZKs=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = with python3Packages; [
    pyyaml
    pyxdg
    evdev
    pyudev
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "evdevremapkeys" ];

  meta = {
    homepage = "https://github.com/philipl/evdevremapkeys";
    description = "Daemon to remap events on linux input devices";
    mainProgram = "evdevremapkeys";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.q3k ];
    platforms = lib.platforms.linux;
  };
})
