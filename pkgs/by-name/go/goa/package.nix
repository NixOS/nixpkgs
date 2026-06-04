{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goa";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4t2yBDCelNlOnptA5kp1fLjfw8H0EXeUJrSiqSpogmc=";
  };
  vendorHash = "sha256-ov+pkaqJRQHrSSK/hb9ScQOiEfUt3j6r5J7YbCledeo=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
  };
})
