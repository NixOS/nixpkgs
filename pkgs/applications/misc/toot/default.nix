{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev = "refs/tags/${version}";
    sha256 = "sha256-JIeL4njMgEfhhmt57vO55NJp7luPtBl1J4zbm0PgYmg=";
  };

  nativeCheckInputs = with python3Packages; [
    flake8
    psycopg2
    pytest
    pytest-xdist
  ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future wcwidth urwid psycopg2 ];

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

