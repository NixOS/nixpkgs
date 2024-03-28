{ lib
, pkgs
, fetchFromGitHub
, rustPlatform
, pkg-config
}:
let
in
rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "unstable-2023-10-16";
  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "swhkd";
    rev = "30f25b5bf99df5f16d91b51a7bd397c1de075085";
    hash = "sha256-K05v2xw7G/ZJsf62g696TOSZHMAOWf24sT9JcvvBNx0=";
  };
  cargoHash = "sha256-mHLrjNVgB5Fxo1Iv4VuHd7ZWQBIiCQK7A+BOfrYdR54=";
  buildInputs = with pkgs; [ systemd ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
  meta = {
    description = "A hotkey daemon for Wayland, X11 and TTY";
    homepage = "https://github.com/waycrate/swhkd";
    changelog = "https://github.com/waycrate/swhkd/blob/main/CHANGELOG.md";
    license = lib.licenses.bsd2;
    mainProgram = "swhkd";
    maintainers = with lib.maintainers; [ ivandimitrov8080 ];
  };
}
