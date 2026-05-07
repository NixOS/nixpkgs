{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dblab";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0tkIDWAub+wfoJ760m1kU7XYnGNner/zLtCod6UPF60=";
  };

  vendorHash = "sha256-B5wyERNUkJIrKjKET9HX3F43CFW6aBtzAarkAuhxw9o=";

  ldflags = [ "-s -w -X main.version=${finalAttrs.version}" ];

  # some tests require network access
  doCheck = false;

  meta = {
    description = "Database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
