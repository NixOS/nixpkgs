{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "git-crecord";
  version = "20161216.0";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = "git-crecord";
    rev = version;
    sha256 = "0v3y90zi43myyi4k7q3892dcrbyi9dn2q6xgk12nw9db9zil269i";
  };

  propagatedBuildInputs = with pythonPackages; [ docutils ];

  meta = {
    homepage = "https://github.com/andrewshadura/git-crecord";
    description = "Git subcommand to interactively select changes to commit or stage";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
