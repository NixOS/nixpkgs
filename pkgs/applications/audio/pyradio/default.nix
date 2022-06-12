{ lib, python3Packages, fetchFromGitHub, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.8.9.20";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-wSu6vTvBkH7vC2c+jj6zaRaR1Poarsgxa5i2mN0dnoE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with python3Packages; [
    requests
    psutil
    dnspython
  ];

  checkPhase = ''
    $out/bin/pyradio --help
  '';

  postInstall = ''
    installManPage *.1
  '';

  meta = with lib; {
    homepage = "http://www.coderholic.com/pyradio/";
    description = "Curses based internet radio player";
    license = licenses.mit;
    maintainers = with maintainers; [ contrun ];
  };
}
