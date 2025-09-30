{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-RI5+SbVPtIEaudNV+S/HiKDATRy93CIQX/RvNJmBoos=";
  };

  cargoHash = "sha256-i6ovc8aWgB9mABuSetdFNPKjOIRKFig2mbowY2djxWA=";

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
}
