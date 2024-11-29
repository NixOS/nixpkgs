{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mvt";
  pyproject = true;
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "mvt-project";
    repo = "mvt";
    rev = "refs/tags/v${version}";
    hash = "sha256-xDUjyvOsiweRqibTe7V8I/ABeaahCoR/d5w23qixp9A";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    adb-shell
    appdirs
    click
    cryptography
    libusb1
    iosbackup
    packaging
    pyahocorasick
    pyyaml
    requests
    rich
    simplejson
    tld
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-mock
    stix2
  ];

  meta = {
    description = "Tool to facilitate the consensual forensic analysis of Android and iOS devices";
    homepage = "https://docs.mvt.re/en/latest/";
    # https://github.com/mvt-project/mvt/blob/main/LICENSE
    license = lib.licenses.unfree;
    changelog = "https://github.com/mvt-project/mvt/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
