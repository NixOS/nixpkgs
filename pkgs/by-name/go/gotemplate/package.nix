{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {

  pname = "gotemplate";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = "gotemplate";
    tag = "v${version}";
    hash = "sha256-XcSlQ0Gw+EW2sJK+M2Sp9pcSSy2wsdRZ3MeFewhx7nw=";
  };

  vendorHash = "sha256-iNH0YmmZ/Qlc7WDoIbORd+uVg0rbQVKL6hX7YvbL0BE=";

  # This is the value reported when running `gotemplate --version`,
  # see https://github.com/coveooss/gotemplate/issues/262
  ldflags = [ "-X main.version=${version}" ];

  meta = {
    description = "CLI for go text/template";
    mainProgram = "gotemplate";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.giorgiga ];
  };

}
