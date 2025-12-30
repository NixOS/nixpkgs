{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  xdotool,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "gridix";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Gridix";
    rev = "v${version}";
    hash = "sha256-RVOD6PdneFjA/CXsWyRpbx7/oICKXYov5Dm0aimdCTY=";
  };

  cargoHash = "sha256-VFgLpZHHqcH2mwhoPlBtgNX/5SahLcBXQUWGWnN2Xhs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    xdotool
    openssl
  ];

  meta = {
    description = "Fast, secure, cross-platform database management tool with Helix/Vim keybindings";
    homepage = "https://github.com/MCB-SMART-BOY/Gridix";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "gridix";
    platforms = lib.platforms.linux;
  };
}
