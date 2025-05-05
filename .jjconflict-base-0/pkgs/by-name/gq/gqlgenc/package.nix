{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-AGbE+R3502Igl4/HaN8yvFVJBsKQ6iVff8IEvddJLEo=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-kBv9Kit5KdPB48V/g1OaeB0ABFd1A1I/9F5LaQDWxUE=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ wattmto ];
  };
}
