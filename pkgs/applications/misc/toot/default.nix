{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.25.0";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = version;
    sha256 = "0padc5jbr55spgbp4avk2kj3if52vzn8dg4ch5jc3h5fvb9l8xz1";
  };

  checkInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future wcwidth urwid ];

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

