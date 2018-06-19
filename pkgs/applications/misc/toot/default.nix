{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.18.0";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = "${version}";
    sha256 = "0snvxn7ifbkrdnml66pdna7vny3qa0s6gcjjz69s7scc0razwrh8";
  };

  checkInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.mit;
    maintainers = [ ];
  };

}

