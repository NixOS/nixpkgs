{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-licence-detector";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "go-licence-detector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EF1DN83kushDvuJFkTHawQ7DEmdhZ9BBO3XT6eZ18VA=";
  };

  vendorHash = "sha256-mEi/aMPdygwiQHuGU1tz82IOanOD15VYpdEePDzCwOU=";

  meta = {
    description = "Detect licences in Go projects and generate documentation";
    homepage = "https://github.com/elastic/go-licence-detector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
