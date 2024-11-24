{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:
buildGo123Module rec {

  pname = "gotemplate";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = "gotemplate";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q/Bqb0wgKzR0WPUHge/hqIvib/TbGxv6s+eEpDLxqPY=";
  };

  vendorHash = "sha256-buRCG9I5zltIMTu5SLE98/pQAs3Vlfw4oz2BZXQxUAc=";

  # This is the value reported when running `gotemplate --version`,
  # see https://github.com/coveooss/gotemplate/issues/262
  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    description = "CLI for go text/template";
    mainProgram = "gotemplate";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };

}
