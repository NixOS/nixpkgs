{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "integresql";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "allaboutapps";
    repo = "integresql";
    rev = "v${version}";
    hash = "sha256-heRa1H4ZSCZzSMCejhakBpJfnEnGQLmNFERKqMxbC04=";
  };

  vendorHash = "sha256-8qI7mLgQB0GK2QV6tZmWU8hJX+Ax1YhEPisQbjGoJRc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/allaboutapps/integresql/internal/config.Commit=${src.rev}"
    "-X github.com/allaboutapps/integresql/internal/config.ModuleName=github.com/allaboutapps/integresql"
  ];

  postInstall = ''
    mv $out/bin/server $out/bin/integresql
  '';

  doCheck = false;

  meta = with lib; {
    description = "IntegreSQL manages isolated PostgreSQL databases for your integration tests";
    homepage = "https://github.com/allaboutapps/integresql";
    changelog = "https://github.com/allaboutapps/integresql/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "integresql";
  };
}
