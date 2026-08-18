{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-jira";
  version = "1.0.28";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "go-jira";
    repo = "jira";
    sha256 = "sha256-h/x77xGqdOxPBxdchElZU9GFgjnNo89o9gx4fYM5dME=";
  };

  vendorHash = "sha256-r69aFl3GwgZ1Zr4cEy4oWlqsrjNCrqjwW9BU9+d8xDQ=";

  doCheck = false;

  meta = {
    description = "Simple command line client for Atlassian's Jira service written in Go";
    homepage = "https://github.com/go-jira/jira";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlosdagos
      timstott
    ];
  };
})
