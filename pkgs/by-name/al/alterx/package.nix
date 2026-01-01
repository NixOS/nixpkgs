{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "alterx";
<<<<<<< HEAD
  version = "0.1.0";
=======
  version = "0.0.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "alterx";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aqCsPv+vxO45SwUXwicjQdGNq+Ad4awiF/wwGlPETDU=";
  };

  vendorHash = "sha256-13ODJNo6xbQkubaGJT3svFbOLbdsHluTCp1Gom+jYeU=";

  meta = {
    description = "Fast and customizable subdomain wordlist generator using DSL";
    homepage = "https://github.com/projectdiscovery/alterx";
    changelog = "https://github.com/projectdiscovery/alterx/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "alterx";
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
