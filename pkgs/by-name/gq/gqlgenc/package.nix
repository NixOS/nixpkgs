{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-3Qz1o91IPKjhzIYzKcdl456AWn6nsrcQ04VglBlpe54=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-Ax5MA4wqQdXSDEIkiG5TcvFIN6YtyXuiJOdQGPYIb+Y=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ wattmto ];
  };
}
