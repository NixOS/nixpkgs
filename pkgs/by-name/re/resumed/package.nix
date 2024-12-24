{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "resumed";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "rbardini";
    repo = "resumed";
    rev = "v${version}";
    hash = "sha256-XaEK41UBKUldjRlxTzc42K/RwZ9D8kueU/6dm8n1W1U=";
  };

  npmDepsHash = "sha256-r0wq1KGZA5b4eIQsp+dz8Inw8AQA62BK7vgfYlViIrY=";

  meta = with lib; {
    description = "Lightweight JSON Resume builder, no-frills alternative to resume-cli";
    homepage = "https://github.com/rbardini/resumed";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "resumed";
  };
}
