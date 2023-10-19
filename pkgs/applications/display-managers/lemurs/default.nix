{
  fetchFromGitHub,
  lib,
  linux-pam,
  rustPlatform,
  testers,
  lemurs,
}:
rustPlatform.buildRustPackage rec {
  pname = "lemurs";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = "lemurs";
    rev = "v${version}";
    hash = "sha256-YDopY+wdWlVL2X+/wc1tLSSqFclAkt++JXMK3VodD4s=";
  };

  cargoHash = "sha256-uuHPJe+1VsnLRGbHtgTMrib6Tk359cwTDVfvtHnDToo=";

  # Fixes a lock issue
  preConfigure = "cargo update --offline";

  buildInputs = [
    linux-pam
  ];

  passthru.tests.version = testers.testVersion {
    package = lemurs;
  };

  meta = with lib; {
    description = "A customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = with licenses; [asl20 mit];
    maintainers = with maintainers; [jeremiahs];
    mainProgram = "lemurs";
  };
}
