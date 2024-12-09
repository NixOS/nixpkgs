{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kdlfmt";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    rev = "v${version}";
    hash = "sha256-Lv4BMhMsi2GBzIsFS2HGZcwENgU1vvgPDZUPBb9ucfo=";
  };

  cargoHash = "sha256-2Lh5jtLsY67e38Xa+GGRBg9L/WIE/Nnd6XDI4crtrTc=";

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt.git";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "kdlfmt";
  };
}
