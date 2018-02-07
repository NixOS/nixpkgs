{ fetchFromGitHub, pythonPackages, stdenv }:

pythonPackages.buildPythonApplication rec {
  ver = "0.8.5";
  name = "gitless-${ver}";

  src = fetchFromGitHub {
    owner = "sdg-mit";
    repo = "gitless";
    rev = "v${ver}";
    sha256 = "1v22i5lardswpqb6vxjgwra3ac8652qyajbijfj18vlkhajz78hq";
  };

  propagatedBuildInputs = with pythonPackages; [ sh pygit2 clint ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://gitless.com/;
    description = "A version control system built on top of Git";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.cransom ];
  };
}

