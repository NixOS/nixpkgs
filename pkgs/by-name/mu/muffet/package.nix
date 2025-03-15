{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.8";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-vpckg0zx8RNR7dAKjdlSHyevn7kDslrysah8jCLSaBw=";
  };

  vendorHash = "sha256-IbpTQdJ6OssyzwS2H4iNgJybC9rvvlW6UYkihNkBYOE=";

  meta = with lib; {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
