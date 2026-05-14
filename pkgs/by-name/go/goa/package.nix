{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goa";
  version = "3.23.4";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7+hOXJU2a39ytn08FlR/YAhOnAmVL5JxdcvF1AlOxHk=";
  };
  vendorHash = "sha256-VSjiEgkjLMFRThNI4G7O91wpF8CYaIVYOrtE49S/o3w=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
  };
})
