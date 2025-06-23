{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lintspec";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${version}";
    hash = "sha256-xT+2gDaKwjnBZBmeY/5UDka/EFodRGflb433BfDeuuk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-r9CRu0zLvsllo3v8E1C8VxmsMbhOQxY8H/imZt04Nok=";

  meta = {
    description = "Blazingly fast linter for NatSpec comments in Solidity code";
    homepage = "https://github.com/beeb/lintspec";
    changelog = "https://github.com/beeb/lintspec/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "lintspec";
  };
}
