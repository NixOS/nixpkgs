{ fetchFromGitHub, python, lib }:

with python.pkgs;
buildPythonApplication rec {
  pname = "gitless";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "sdg-mit";
    repo = "gitless";
    rev = "v${version}";
    sha256 = "1q6y38f8ap6q1livvfy0pfnjr0l8b68hyhc9r5v87fmdyl7y7y8g";
  };

  propagatedBuildInputs = with pythonPackages; [ sh pygit2 clint ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://gitless.com/";
    description = "A version control system built on top of Git";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.cransom ];
  };
}

