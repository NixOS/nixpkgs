{ lib, buildPythonApplication, fetchFromGitHub, cram }:

buildPythonApplication {
  pname = "t";
  version = "unstable-2020-04-11";

  src = fetchFromGitHub {
    owner = "sjl";
    repo = "t";
    rev = "815ccaf4f0bf2acb2a7f2cb330bf0532d782f408";
    sha256 = "1bi2hpdgwbqhcy88laba7h6kiqxvz75qqaf6sq221n39zfdl8n1g";
  };

  checkInputs = [ cram ];

  checkPhase = ''
    cram -v tests/*
  '';

  meta = with lib; {
    homepage = "https://github.com/sjl/t";
    description = "Simple command-line todo list manager";
    license = licenses.mit;
    maintainers = [ maintainers.illiusdope ];
  };
}
