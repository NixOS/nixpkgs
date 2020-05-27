{ lib, fetchFromGitHub, python3Packages, openvpn, dialog, iptables }:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-cli-ng";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0ixjb02kj4z79whm1izd8mrn2h0rp9cmw4im1qvp93rahqxdd4n8";
  };

  propagatedBuildInputs = (with python3Packages; [
      requests
      docopt
      setuptools
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
    homepage = "https://github.com/protonvpn/protonvpn-cli-ng";
    maintainers = with maintainers; [ jtcoolen jefflabonte ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
