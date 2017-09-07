{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.13.0";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = "${version}";
    sha256 = "0gbsq43qv5qg4avx7czs57k40m8lzh8f1z5yizqqc7r02p2sacnc";
  };

  checkInputs = with pythonPackages; [ pytest ];

  propagatedBuildInputs = with pythonPackages;
    [ requests beautifulsoup4 future ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

