{ lib, fetchFromGitHub, python3Packages, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.41.1";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev = "refs/tags/${version}";
    sha256 = "sha256-FwxA8YJzNKEK5WjdDi8PIufHh+SRVMRiFVIQs1iZ0UY=";
  };

  nativeCheckInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
  [
    requests beautifulsoup4 future wcwidth
    urwid urwidgets psycopg2 tomlkit click
  ];

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
