{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "pkarr";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkarr";
    rev = "v${version}";
    hash = "sha256-564JL7EG/RB2k2JdxAENpP5UZtKtaGlrZfeYOgsLBEY=";
  };

  cargoHash = "sha256-HG4cmKQleiWdYBrOgv1Aj/erWjZX5PMwIZpQSQc+sFU=";

  meta = {
    description = "Public Key Addressable Resource Records (sovereign TLDs) ";
    homepage = "https://github.com/pubky/pkarr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "pkarr-server";
  };
}
