{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgcenter";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "lesovsky";
    repo = "pgcenter";
    rev = "v${version}";
    sha256 = "sha256-xaY01T12/5Peww9scRgfc5yHj7QA8BEwOK5l6OedziY=";
  };

  vendorHash = "sha256-9hYiyZ34atmSL7JvuXyiGU7HR4E6qN7bGZlyU+hP+FU=";

  subPackages = [ "cmd" ];

  ldflags = [
    "-w"
    "-s"
    "-X main.gitTag=${src.rev}"
    "-X main.gitCommit=${src.rev}"
    "-X main.gitBranch=master"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pgcenter
  '';

  doCheck = false;

  meta = {
    homepage = "https://pgcenter.org/";
    changelog = "https://github.com/lesovsky/pgcenter/raw/v${version}/doc/Changelog";
    description = "Command-line admin tool for observing and troubleshooting PostgreSQL";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pgcenter";
  };
}
