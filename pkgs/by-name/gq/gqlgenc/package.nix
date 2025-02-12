{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.30.3";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-NYH05VppoIjxOzMP6aBBtZLxf8cj1kdzS+5NKtIDcik=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-h3ePmfRkGqVXdtjX2cU5y2HnX+VkmTWNwrEkhLAmrlU=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ wattmto ];
  };
}
