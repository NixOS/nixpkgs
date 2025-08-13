{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "inframap";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = "inframap";
    tag = "v${version}";
    hash = "sha256-IdXP/gw81rQsaHz+uwEB9ThtHlbPYLXcYTYdwJynpVU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cycloidio/inframap/cmd.Version=${version}"
  ];

  vendorHash = "sha256-cEKrxuuksMEEVJEZ9/ZU2/MMxWZKlO05DkNX4n3ug/0=";

  meta = with lib; {
    description = "Read your tfstate or HCL to generate a graph specific for each provider, showing only the resources that are most important/relevant";
    homepage = "https://github.com/cycloidio/inframap";
    changelog = "https://github.com/cycloidio/inframap/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
