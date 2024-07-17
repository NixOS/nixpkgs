{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "netproxrc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "netproxrc";
    rev = "version-${version}";
    hash = "sha256-LyHFaT5kej1hy5z28XP+bOSCEj5DHqwMRkvrv/5inQU=";
  };

  vendorHash = "sha256-LWNn5qp+Z/M9xTtOZ5RDHq1QEFK/Y2XgBi7H5S7Z7XE=";

  meta = with lib; {
    description = "HTTP proxy injecting credentials from a .netrc file";
    mainProgram = "netproxrc";
    homepage = "https://github.com/timbertson/netproxrc";
    license = licenses.mit;
    maintainers = with maintainers; [ timbertson ];
  };
}
