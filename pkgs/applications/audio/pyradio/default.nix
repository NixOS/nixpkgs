{ lib, python3Packages, fetchFromGitHub, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.8.9.25";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-bkZ+zgFtENQUjks9HwVcqHIREcKQ5XCt3AEh3QAyiEc=";
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
