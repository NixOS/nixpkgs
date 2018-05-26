{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.17.1";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = "${version}";
    sha256 = "05fzsakm089bn03z8gip6yp4xfmwa054v40x2f3gqpl04r504gis";
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

