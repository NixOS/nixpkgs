{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mvt";
  pyproject = true;
  version = "2.5.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u1OdhTrSfWSZrL4D+fRoa4c4xiS2jSJuF5T6E1jx3Q4=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    adb-shell
    appdirs
    click
    cryptography
    libusb1
    iOSbackup
    packaging
    pyahocorasick
    pyyaml
    requests
    rich
    simplejson
    tld
  ];

  meta = {
    description = "Tool to facilitate the consensual forensic analysis of Android and iOS devices";
    homepage = "https://docs.mvt.re/en/latest/";
    license = lib.licenses.mvt;
    changelog = "https://github.com/mvt-project/mvt/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
