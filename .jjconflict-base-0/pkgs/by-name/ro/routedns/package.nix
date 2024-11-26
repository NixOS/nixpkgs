{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "routedns";
  version = "0.1.51";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${version}";
    hash = "sha256-9H/l6EAbrNwD2DnweBqjmcoaJEnTH9BdGn2x/ZC3us4=";
  };

  vendorHash = "sha256-yOYeMYAXa1jok8QwGtYsvuUGgIXEjZGo6+FiDQkZwUU=";

  subPackages = [ "./cmd/routedns" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/folbricht/routedns";
    description = "DNS stub resolver, proxy and router";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jsimonetti ];
    mainProgram = "routedns";
  };
}
