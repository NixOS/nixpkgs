{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "alterx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "alterx";
    tag = "v${version}";
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
  };
}
