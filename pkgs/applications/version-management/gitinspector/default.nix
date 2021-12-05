{ lib, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "gitinspector";
  version = "0.4.4";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "ejwa";
    repo = "gitinspector";
    rev = "v${version}";
    sha256 = "sha256-9bChvE5aAZFunu599pH7QKHZFd7aQzv0i9LURrvh2t0=";
  };

  checkInputs = with python2Packages; [ unittest2 ];

  meta = with lib; {
    homepage = "https://github.com/ejwa/gitinspector";
    description = "Statistical analysis tool for git repositories";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
