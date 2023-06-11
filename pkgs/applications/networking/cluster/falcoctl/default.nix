{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "falcoctl";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    rev = "v${version}";
    hash = "sha256-+6q7U/ipyIuoOPVo+yFuj2r3WAA2AozSqxjj4f5of68=";
  };

  vendorHash = "sha256-12n5OZtrPSl+XUm+wsaTI5SVfJz/aGEhNQdMyEOGhkw=";


  ldflags = [
    "-s"
    "-w"
    "-X github.com/falcosecurity/falcoctl/cmd/version.semVersion=${version}"
  ];

  meta = with lib; {
    description = "Administrative tooling for Falco";
    homepage = "https://github.com/falcosecurity/falcoctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ developer-guy kranurag7 LucaGuerra ];
  };
}
