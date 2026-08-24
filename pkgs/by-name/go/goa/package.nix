{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goa";
  version = "3.29.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UgjqcQe1piJDlQJeQjsFSEeX8pNnIw81tsR5+Wmlesk=";
  };
  vendorHash = "sha256-JfpBv49AO/YJ9Scz22IgxhwF+EUnS4brGtbmpMB+B/Y=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
  };
})
