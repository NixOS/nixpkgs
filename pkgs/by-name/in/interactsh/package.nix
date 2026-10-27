{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "interactsh";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "interactsh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kso++52oYvfs5LC65iS7gIxNKN7+XbAHrs0KP8cUH7g=";
  };

  vendorHash = "sha256-BS6Wg5w+csmzqO4iQ/W5caQz9YQLZgEJcKBaqnaVNqs=";

  modRoot = ".";
  subPackages = [
    "cmd/interactsh-client"
    "cmd/interactsh-server"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = {
    description = "Out of bounds interaction gathering server and client library";
    longDescription = ''
      Interactsh is an Open-Source Solution for Out of band Data Extraction,
      A tool designed to detect bugs that cause external interactions,
      For example - Blind SQLi, Blind CMDi, SSRF, etc.
    '';
    homepage = "https://github.com/projectdiscovery/interactsh";
    changelog = "https://github.com/projectdiscovery/interactsh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hanemile ];
  };
})
