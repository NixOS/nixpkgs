{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-HSC0G0Ll8geBwd4eBhk5demL2likhMZqlkYGcbzNOck=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5i4lfW21QJzVReUGdgeymI1tBX367qBu8yveVFtgORI=";

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
}
