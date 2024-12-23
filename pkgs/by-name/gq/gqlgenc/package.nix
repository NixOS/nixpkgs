{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-NqFF3ppdg3nUZJ3ij0Zx3uKXz4Xhr/JEnkAzYNbPqOE=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-ln26CHD0q+iPyAx5DalOGyCtVB1QR+7ls1ZjNK8APBU=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ wattmto ];
  };
}
