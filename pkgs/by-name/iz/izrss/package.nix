{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.0.6";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "refs/tags/v${version}";
    hash = "sha256-tO/m39FMtvxZzNgnVY84k4J2v8vQVdzR3IKofJWCf9U=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-/gD82wT4jWNMQsGPb2nYQiFQsUdKICyO6eiRPHrLsy8=";

  meta = {
    description = "An RSS feed reader for the terminal written in Go";
    changelog = "https://github.com/isabelroses/izrss/releases/v${version}";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
}
