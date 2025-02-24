{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kdlfmt";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    rev = "v${version}";
    hash = "sha256-bBb+uWU8RuLRmosBaOdx9yZkWhARTn3ObxwART8wTE0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-g3GjAwnY9khwnTVoUEWJuY95YCNyRedGXISQtpguI8g=";

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt.git";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "kdlfmt";
  };
}
