{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "pkarr";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkarr";
    rev = "v${version}";
    hash = "sha256-9sTF5h2+vWcz5ohAoo95vldTJGQyz/ICkVpIgaxilwA=";
  };

  cargoHash = "sha256-26OlV/Xnl1+VFOaCWUjb8LxuJWrCsfY7QTlPZ7VMBCs=";

  meta = {
    description = "Public Key Addressable Resource Records (sovereign TLDs) ";
    homepage = "https://github.com/pubky/pkarr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "pkarr-server";
  };
}
