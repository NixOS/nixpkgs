{ stdenv, buildPythonApplication, fetchFromGitHub, isPy27, pytest, testfixtures, lib }:

buildPythonApplication rec {
  pname = "bump2version";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "c4urself";
    repo = "${pname}";
    rev = "refs/tags/v${version}";
    sha256 = "10p7rg569rk3qvzs5kjj17894bqlsg3ihhbln6ciwwfhkfq1kpja";
  };

  checkInputs = [ pytest testfixtures ];
  # X's in pytest are git tests which won't run in sandbox
  checkPhase = ''
    pytest tests/ -k 'not usage_string_fork'
  ''; 

  meta = with stdenv.lib; {
    description = "Version-bump your software with a single command";
    longDescription = ''
      A small command line tool to simplify releasing software by updating 
      all version strings in your source code by the correct increment.
    '';
    homepage = "https://github.com/c4urself/bump2version";
    license = licenses.mit;
    maintainers = with maintainers; [ jefflabonte ];
  };
}
