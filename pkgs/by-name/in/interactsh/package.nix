{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "interactsh";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "interactsh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hbhVa+tXXJxSOeQqSFWcKKFv3tjcXhnCjqxLzg7/d+Q=";
  };

  vendorHash = "sha256-g7dGmkxqj2UWap7TfNxocb93C7K0R76sAKD+n2kxDGo=";

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
