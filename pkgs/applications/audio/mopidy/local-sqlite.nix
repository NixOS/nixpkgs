{ stdenv, fetchFromGitHub, python2Packages, mopidy }:

python2Packages.buildPythonApplication rec {
  pname = "mopidy-local-sqlite";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-local-sqlite";
    rev = "v${version}";
    sha256 = "1fjd9ydbfwd1n9b9zw8zjn4l7c5hpam2n0xs51pjkjn82m3zq9zv";
  };

  propagatedBuildInputs = [
    mopidy
    python2Packages.uritools
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mopidy/mopidy-local-sqlite;
    description = "Mopidy SQLite local library extension";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
