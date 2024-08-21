{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scalingo";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
    hash = "sha256-7hb1RU33wGeSESxY16pYJfQ2O3QOT92Em6jlh8oP/Zc=";
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
    mainProgram = "scalingo";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
