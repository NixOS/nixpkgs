{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ddns-go";
  version = "6.17.8";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-28//o+z7qnbmyxoCSV68LjyTHJP3wt2shTOC3vjfKW8=";
  };

  vendorHash = "sha256-BFPWDBGBvWWm7wHwrRNxl4agYcvlzVGD+BNsYJ5fi84=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  # network required
  doCheck = false;

  meta = {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "ddns-go";
  };
})
