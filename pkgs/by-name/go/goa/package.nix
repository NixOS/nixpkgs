{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.20.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-nkL1os+evGy6L0Ura2PSDBhF25L6fLTnoYkT/5S9H9U=";
  };
  vendorHash = "sha256-lO5cI7h0xtWFbHbAiRnG6kFx/74E47Mw79AFMuNz6XU=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
