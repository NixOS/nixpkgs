{ stdenv, lib, fetchFromGitHub, python3Packages, openvpn, dialog }:

python3Packages.buildPythonApplication rec {
  name = "protonvpn-cli-ng";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "protonvpn-cli-ng";
    rev = "v${version}";
    sha256 = "11fvnnr5p3qdc4y10815jnydcjvxlxwkkq9kvaajg0yszq84rwkz";
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
    maintainers = [ maintainers.jtcoolen ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
