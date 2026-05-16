{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  libevdev,
  paramiko,
  pynput,
  screeninfo,
  tkinter,
  hatchling,
}:

buildPythonApplication (finalAttrs: {
  pname = "remarkable-mouse";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "Evidlo";
    repo = "remarkable_mouse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/p+Vg5SzyIH2m0OWthKQ3xgV1KJlAlr1M0bdIi8O2Po=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  pyproject = true;
  build-system = [
    hatchling
  ];

  dependencies = [
    screeninfo
    paramiko
    pynput
    libevdev
    tkinter
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "remarkable_mouse" ];

  meta = {
    description = "Program to use a reMarkable as a graphics tablet";
    homepage = "https://github.com/evidlo/remarkable_mouse";
    changelog = "https://github.com/Evidlo/remarkable_mouse/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nickhu ];
  };
})
