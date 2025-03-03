{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "nping";
  version = "0.2.6";
  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    rev = "v${version}";
    hash = "sha256-PWsTs2uSTWiLUUNoXR9m198O7HNC5PiUlihkzSoGv/8=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-Qvi8DTzApXVzmT3yV5DULdYz05RhV4i0cLKAQ3y1tGo=";
  meta = with lib; {
    description = "Nping mean NB Ping, A Ping Tool in Rust with Real-Time Data and Visualizations";
    longDescription = ''
      Nping is a Ping tool developed in Rust. It supports concurrent Ping for multiple addresses, visual chart display,
      real-time data updates, and other features.'';
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "nping";
    maintainers = with maintainers; [ pblgomez ];
    platfotms = platforms.unix;
  };
}
