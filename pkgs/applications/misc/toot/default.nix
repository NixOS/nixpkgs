{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.15.0";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = "${version}";
    sha256 = "08k913gw0ip2q686z9k63bcn1n5s4w6b7jj6jmmamm427xmibkph";
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

