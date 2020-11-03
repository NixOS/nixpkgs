{ lib, fetchFromGitHub, python3Packages, openvpn, dialog, iptables }:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-linux-cli";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "linux-cli";
    rev = "v${version}";
    sha256 = "08yca0a0prrnrc7ir7ajd56yxvxpcs4m1k8f5kf273f5whgr7wzw";
  };

  requiredPythonModules = (with python3Packages; [
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
    maintainers = with maintainers; [ jtcoolen jefflabonte ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
