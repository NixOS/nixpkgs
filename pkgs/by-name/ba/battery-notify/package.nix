{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "battery-notify";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    rev = version;
    hash = "sha256-RApjIccTk4xdD9kg/Km6X2lWvBd3sfTvcSoQ2saMpqc=";
  };

  cargoHash = "sha256-2p+FMbanjIWdFgov/DKYk6GfDLZWLOun6By03WtfTeU=";

  meta = with lib; {
    description = "battery-notify is a small, Linux-only program that sends notifications on changes to system or Bluetooth battery state.";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ imadnyc ];
  };
}
