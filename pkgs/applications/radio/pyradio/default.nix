{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.8.7.1";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = pname;
    rev = version;
    sha256 = "1f1dch5vrx2armrff19rh9gpqydspn3nvzc9p9j2jfi6gsxhppyb";
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
