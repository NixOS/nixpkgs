{ lib
, buildPythonApplication
, pythonOlder
, fetchFromGitHub
, protonvpn-nm-lib
, pythondialog
, dialog
}:

buildPythonApplication rec {
  pname = "protonvpn-cli";
  version = "3.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "linux-cli";
    rev = version;
    sha256 = "sha256-u+POtUz7NoGS23aOmvDCZPUp2HW1xXGtfbZR88cWCBc=";
  };

  propagatedBuildInputs = [
    protonvpn-nm-lib
    pythondialog
    dialog
  ];

  # Project has a dummy test
  doCheck = false;

  meta = with lib; {
    description = "Linux command-line client for ProtonVPN";
    homepage = "https://github.com/protonvpn/linux-cli";
    maintainers = with maintainers; [ wolfangaukang ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "protonvpn-cli";
  };
}
