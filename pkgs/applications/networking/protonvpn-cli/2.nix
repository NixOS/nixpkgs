{ lib
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, requests
, docopt
, pythondialog
, jinja2
, distro
, dialog
, iptables
, openvpn }:

buildPythonApplication rec {
  pname = "protonvpn-cli_2";
  version = "2.2.11";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Rafficer";
    repo = "linux-cli-community";
    # There is a tag and branch with the same name
    rev = "refs/tags/v${version}";
    sha256 = "sha256-CWQpisJPBXbf+d5tCGuxfSQQZBeF36WFF4b6OSUn3GY=";
  };

  propagatedBuildInputs = [
    requests
    docopt
    pythondialog
    jinja2
    distro
    dialog
    openvpn
    iptables
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Linux command-line client for ProtonVPN using Openvpn";
    homepage = "https://github.com/Rafficer/linux-cli-community";
    maintainers = with maintainers; [ jtcoolen jefflabonte shamilton ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "protonvpn";
  };
}
