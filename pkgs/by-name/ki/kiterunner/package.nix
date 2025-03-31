{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kiterunner";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "assetnote";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vIYPpkbqyk0zH10DGp2FF0aI4lFpsZavulBIiR/3kiA=";
  };

  vendorHash = "sha256-fgtDP6X84iPO2Tcwq5jl8700PDKixJlIihgNaPX/n9k=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/assetnote/kiterunner/cmd/kiterunner/cmd.Version=${version}"
  ];

  subPackages = [ "./cmd/kiterunner" ];

  # Test data is missing in the repo
  doCheck = false;

  meta = with lib; {
    description = "Contextual content discovery tool";
    mainProgram = "kiterunner";
    longDescription = ''
      Kiterunner is a tool that is capable of not only performing traditional
      content discovery at lightning fast speeds, but also bruteforcing routes
      and endpoints in modern applications.
    '';
    homepage = "https://github.com/assetnote/kiterunner";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
