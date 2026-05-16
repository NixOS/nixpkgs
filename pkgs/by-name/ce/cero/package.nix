{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cero";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "glebarez";
    repo = "cero";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t2u6Q8CatUIQKk146uor367vr85O6KU8Gf8LZFZTESU=";
  };

  vendorHash = "sha256-VwzjkZLKovmPjvEmANMgZTtkwiM+dyjfTqftvK+muPM=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests are comparing output
  doCheck = false;

  meta = {
    description = "Scrape domain names from SSL certificates of arbitrary hosts";
    homepage = "https://github.com/glebarez/cero";
    changelog = "https://github.com/glebarez/cero/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cero";
  };
})
