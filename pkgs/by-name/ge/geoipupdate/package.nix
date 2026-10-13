{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "geoipupdate";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JGJOHFxRjK9N1jWgOwot84biWyNQEvbVXOFqrxRtRlY=";
  };

  vendorHash = "sha256-CRJmTycjg195aYhGp85d1gCbbStaPBsfwKcXljpt4Ko=";

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  doCheck = false;

  meta = {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ helsinki-Jo ];
    mainProgram = "geoipupdate";
  };
})
