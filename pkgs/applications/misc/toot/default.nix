{ lib, fetchFromGitHub, python3Packages, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev = "refs/tags/${version}";
    sha256 = "sha256-gT9xKFanQhptt46nkdzYsZ6Vu0Nab0oRsvEHVRNf8DQ=";
  };

  nativeCheckInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future wcwidth urwid psycopg2 tomlkit ];

  checkPhase = ''
    py.test
  '';

  passthru.tests.toot = nixosTests.pleroma;

  meta = with lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

