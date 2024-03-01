{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scalingo";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
    hash = "sha256-Dzm1f7iNVCzbSogYfjDIHJ2UbPnP1F9nF9QASe/H3TU=";
  };

  vendorHash = null;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    rm $out/bin/dists
  '';

  meta = with lib; {
    description = "Command line client for the Scalingo PaaS";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
