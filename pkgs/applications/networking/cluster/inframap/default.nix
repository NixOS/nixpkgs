{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "inframap";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ol2FkCP7Wq7FcwOaDw9d20v4jkNIfewdMErz/kJR0/g=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cycloidio/inframap/cmd.Version=${version}"
  ];

  vendorHash = "sha256-fD/u0gYfbhyYWjXtBDtL7zWRu7b7mzpLPEjB+ictP6o=";

  meta = with lib; {
    description = "Read your tfstate or HCL to generate a graph specific for each provider, showing only the resources that are most important/relevant.";
    homepage = "https://github.com/cycloidio/inframap";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
