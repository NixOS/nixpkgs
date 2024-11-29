{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cero";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "glebarez";
    repo = "cero";
    rev = "v${version}";
    hash = "sha256-t2u6Q8CatUIQKk146uor367vr85O6KU8Gf8LZFZTESU=";
  };

  vendorHash = "sha256-VwzjkZLKovmPjvEmANMgZTtkwiM+dyjfTqftvK+muPM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Scrape domain names from SSL certificates of arbitrary hosts";
    homepage = "https://github.com/glebarez/cero";
    changelog = "https://github.com/glebarez/cero/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cero";
  };
}
