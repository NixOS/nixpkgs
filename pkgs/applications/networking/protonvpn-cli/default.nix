{ lib, fetchFromGitHub, python3Packages, openvpn, dialog, iptables }:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-linux-cli";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "linux-cli";
    rev = "v${version}";
    sha256 = "0y7v9ikrmy5dbjlpbpacp08gy838i8z54m8m4ps7ldk1j6kyia3n";
  };

  propagatedBuildInputs = (with python3Packages; [
      requests
      docopt
      setuptools
      jinja2
      pythondialog
    ]) ++ [
      dialog
      openvpn
      iptables
    ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Linux command-line client for ProtonVPN";
    homepage = "https://github.com/protonvpn/linux-cli";
    maintainers = with maintainers; [ jtcoolen jefflabonte shamilton ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
