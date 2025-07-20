{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "interactsh";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "interactsh";
    tag = "v${version}";
    hash = "sha256-28d+ghJ/A/dg6aeypqPF4EAhDp8k3yXLYylxnQR/J+M=";
  };

  vendorHash = "sha256-1ZTvIGgFEXxW//d3bD4kYRYj5+n/NzJW2oSnbjyXLGA=";

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
    changelog = "https://github.com/projectdiscovery/interactsh/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hanemile ];
  };
}
