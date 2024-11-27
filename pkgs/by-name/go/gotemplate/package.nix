{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:
buildGo123Module rec {

  pname = "gotemplate";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = "gotemplate";
    rev = "refs/tags/v${version}";
    hash = "sha256-ohF9NemIXTTzguQ2VfqFt9zeiE4Co+dVux9Kw5cDobs=";
  };

  vendorHash = "sha256-iNH0YmmZ/Qlc7WDoIbORd+uVg0rbQVKL6hX7YvbL0BE=";

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
