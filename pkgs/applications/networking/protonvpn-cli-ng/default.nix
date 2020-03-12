{ stdenv, lib, fetchFromGitHub, python3Packages, openvpn, dialog }:

python3Packages.buildPythonApplication rec {
  name = "protonvpn-cli-ng";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "protonvpn-cli-ng";
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
    ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Linux command-line client for ProtonVPN";
    homepage = "https://github.com/protonvpn/protonvpn-cli-ng";
    maintainers = [ maintainers.jtcoolen maintainers.jefflabonte ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
