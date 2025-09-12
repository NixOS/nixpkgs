{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lintspec";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${version}";
    hash = "sha256-TMiUOrDsKXi+d/CbJauo2FT9WEWnztMYqrZZHpS8i7M=";
  };

  cargoHash = "sha256-K8zx+dW6RXcbX2ZqNdfnv7WjbvjA8ZdJBitdDOi8hxE=";

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
