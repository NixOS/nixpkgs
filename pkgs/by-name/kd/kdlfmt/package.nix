{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kdlfmt";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    rev = "v${version}";
    hash = "sha256-OldgEAGvwXBnLIEVI/jGXV9lFp/Ua+n8cQqSWETn3T4=";
  };

  cargoHash = "sha256-Pxs/ITGSU3WErcUgjnehCzuqkeC6M7x2mM/sU00djUw=";

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt.git";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "kdlfmt";
  };
}
