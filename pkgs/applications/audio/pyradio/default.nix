{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.8.9.9";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = pname;
    rev = version;
    sha256 = "04asw5alkkf2q5iixswarj6ddb0y4a6ixm7cckl6204jiyxpv6kc";
  };

  propagatedBuildInputs = with python3Packages; [
    dnspython
    requests
  ];

  prePatch = ''
    sed -i 's/distro = None/distro = NixOS/' pyradio/config
  '';

  checkPhase = ''
    $out/bin/pyradio --help
  '';

  meta = with lib; {
    homepage = "http://www.coderholic.com/pyradio/";
    description = "Curses based internet radio player";
    license = licenses.mit;
    maintainers = with maintainers; [ contrun ];
  };
}
