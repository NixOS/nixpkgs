{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.8.9.14";

  propagatedBuildInputs = with python3Packages; [
    requests
    psutil
    dnspython
  ];

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = pname;
    rev = version;
    sha256 = "sha256-9q+YsQPFB7Ql5WnXvPj100cD7pGkmr1hHztqbpZStt8=";
  };

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
