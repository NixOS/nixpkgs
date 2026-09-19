{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goa";
  version = "3.31.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZTD77OBw/FasqTRb4Vq6oq5U0O+gecRVT6apLQeH6Sc=";
  };
  vendorHash = "sha256-TJOmha/3uU7MBWq37b9tSygmdXsfmdL8QGeqFHBMh+8=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
  };
})
