{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "interactsh";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ugrcGOlVRPTWhIX6Bpzl9iVydiVY5BWN3yNK/CaZS6A=";
  };

  vendorHash = "sha256-HgYaSjg4oFNOTOiUd2YXpdUWdpKqJFF5KDejxp0J4cU=";

  modRoot = ".";
  subPackages = [
    "cmd/interactsh-client"
    "cmd/interactsh-server"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "Out of bounds interaction gathering server and client library";
    longDescription = ''
      Interactsh is an Open-Source Solution for Out of band Data Extraction,
      A tool designed to detect bugs that cause external interactions,
      For example - Blind SQLi, Blind CMDi, SSRF, etc.
    '';
    homepage = "https://github.com/projectdiscovery/interactsh";
    changelog = "https://github.com/projectdiscovery/interactsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}
