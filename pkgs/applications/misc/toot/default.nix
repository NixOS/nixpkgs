{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = version;
    sha256 = "076r6l89gxjwxjpiklidcs8yajn5c2bnqjvbj4wc559iqdqj88lz";
  };

  checkInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future wcwidth urwid ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

