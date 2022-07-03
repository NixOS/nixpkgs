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
  version = "3.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "linux-cli";
    rev = version;
    sha256 = "sha256-z0ewAqf8hjyExqBN8KBsDwJ+SA/pIBYZhKtXF9M65HE=";
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
