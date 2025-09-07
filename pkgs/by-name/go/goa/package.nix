{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.21.5";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-3MRxiZK6rLc0Drn3Ha7YOZO3IGNkQNEpzppZwYcZLwg=";
  };
  vendorHash = "sha256-5XKAfUA3dh1Vgh72h1GeiheoL7E7jij3nAlncV5FjF8=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
