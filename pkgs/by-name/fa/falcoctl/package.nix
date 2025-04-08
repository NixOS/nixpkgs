{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "falcoctl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    rev = "v${version}";
    hash = "sha256-X4fZBTEbOIQbfmuxDODEkYW43ntVIkwFDULYq+ps+9s=";
  };

  vendorHash = "sha256-26EXoXMWK/zPX4M7kG3QRAb4aqtIWgSnSgXcxKUwfZk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/falcosecurity/falcoctl/cmd/version.semVersion=${version}"
  ];

  meta = with lib; {
    description = "Administrative tooling for Falco";
    mainProgram = "falcoctl";
    homepage = "https://github.com/falcosecurity/falcoctl";
    license = licenses.asl20;
    maintainers = with maintainers; [
      developer-guy
      kranurag7
      LucaGuerra
    ];
  };
}
