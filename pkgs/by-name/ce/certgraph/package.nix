{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "certgraph";
  version = "20220513.20220514.0";

  src = fetchFromGitHub {
    owner = "lanrat";
    repo = "certgraph";
    tag = "v${version}";
    sha256 = "sha256-OQkPWImUPgn8kQ1Ong1D+0y/rUjHitsE4UPwMcrKbvc=";
  };

  proxyVendor = true;

  vendorHash = "sha256-l1tjBG9qXCtys6WIT7JysWQZjMje7lXmXmvyMrpNj9U=";

  meta = {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    mainProgram = "certgraph";
    homepage = "https://github.com/lanrat/certgraph";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
