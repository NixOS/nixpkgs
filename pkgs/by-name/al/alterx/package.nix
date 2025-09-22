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

  meta = {
    description = "Fast and customizable subdomain wordlist generator using DSL";
    mainProgram = "alterx";
    homepage = "https://github.com/projectdiscovery/alterx";
    changelog = "https://github.com/projectdiscovery/alterx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
