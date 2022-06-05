{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript }:

buildKodiAddon rec {
  pname = "urllib3";
  namespace = "script.module.urllib3";
  version = "1.26.8+matrix.1";

  # temporarily fetching from a PR because of CVE-2021-33503
  # see https://github.com/xbmc/repo-scripts/pull/2193 for details
  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "repo-scripts";
    rev = "f0bfacab4732e33c5669bedd1a86319fa9e38338";
    sha256 = "sha256-UEMLrIvuuPARGHMsz6dOZrOuHIYVSpi0gBy2lK1Y2sk=";
  };

  sourceRoot = "source/script.module.urllib3";

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://urllib3.readthedocs.io/en/latest/";
    description = "HTTP library with thread-safe connection pooling, file post, and more";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
