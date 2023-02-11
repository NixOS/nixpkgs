{ buildPythonApplication, fetchFromGitHub, nose, openjdk, lib }:

buildPythonApplication rec {
  pname = "html5validator";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "svenkreiss";
    repo = "html5validator";
    rev = "v${version}";
    sha256 = "130acqi0dsy3midg7hwslykzry6crr4ln6ia0f0avyywkz4bplsv";
  };

  propagatedBuildInputs = [ openjdk ];

  nativeCheckInputs = [ nose ];
  checkPhase = "PATH=$PATH:$out/bin nosetests";

  meta = with lib; {
    homepage = "https://github.com/svenkreiss/html5validator";
    description = "Command line tool that tests files for HTML5 validity";
    license = licenses.mit;
    maintainers = [ maintainers.phunehehe ];
  };
}
