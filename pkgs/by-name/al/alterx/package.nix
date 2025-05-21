{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "alterx";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "alterx";
    tag = "v${version}";
    hash = "sha256-IjCK0TVZOBegNdfpqOFoOTuj8KtmCuIqNPvcIa1vSo0=";
  };

  vendorHash = "sha256-aTA5KGeYmJnbVRbEhT9LigQoJFLD17q9spzBV4BGhNw=";

  meta = with lib; {
    description = "Fast and customizable subdomain wordlist generator using DSL";
    mainProgram = "alterx";
    homepage = "https://github.com/projectdiscovery/alterx";
    changelog = "https://github.com/projectdiscovery/alterx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
