{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scalingo";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
    hash = "sha256-vgkVxQK18RBIhhL9gyuH9kmCueJFDZByhy0FE4JuVO8=";
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
