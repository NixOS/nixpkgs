{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "clapboard";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "clapboard";
    rev = "v${version}";
    hash = "sha256-1y2tG4ajnsstNkPTE3eBr8QJJF6Qq/HCQzJoj1ETuUY=";
  };

  cargoHash = "sha256-DEwipAG/zPPftYwYahRJfpXgHPXerGdn10PkS8DHWCM=";

  meta = with lib; {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = licenses.mit;
    maintainers = with maintainers; [
      dit7ya
      bjesus
    ];
    platforms = platforms.linux;
    mainProgram = "clapboard";
  };
}
