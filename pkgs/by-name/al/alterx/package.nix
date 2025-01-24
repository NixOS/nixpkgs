{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "alterx";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "alterx";
    rev = "refs/tags/v${version}";
    hash = "sha256-A01XROFB2NkArfFtRMv/r9Nu5QoKMTOVzVIUnFoVe78=";
  };

  vendorHash = "sha256-efwU41kFR8QYa2cevvj4pYAXgCisJ4OHaRIhWVnETvc=";

  meta = with lib; {
    description = "Fast and customizable subdomain wordlist generator using DSL";
    mainProgram = "alterx";
    homepage = "https://github.com/projectdiscovery/alterx";
    changelog = "https://github.com/projectdiscovery/alterx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
