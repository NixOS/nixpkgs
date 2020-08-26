{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.27.0";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = version;
    sha256 = "197g9lvwg8qnsf18kifcqdj3cpfdnxz9vay766rn9bi4nfz0s6j2";
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
    license     = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

