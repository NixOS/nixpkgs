{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-yHls7qGZhQIIYbPWCs0dm3W2DgKZq4fJbnNCPTqUy/s=";
  };
  vendorHash = "sha256-mKFKZuAIQdDwDJ2DMtW18NgFn6Sd35TQHBY4xVKzoUs=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
