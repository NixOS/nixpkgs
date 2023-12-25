{ lib
, pkgs
, stdenv
, fetchFromGitHub
, rustPlatform
}:
let
  name = "swhkd";
  version = "30f25b5bf99df5f16d91b51a7bd397c1de075085";
  buildInputs = with pkgs; [ systemd ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
in
rustPlatform.buildRustPackage rec {
  inherit name buildInputs nativeBuildInputs;
  src = fetchFromGitHub {
    owner = "waycrate";
    repo = name;
    rev = version;
    hash = "sha256-K05v2xw7G/ZJsf62g696TOSZHMAOWf24sT9JcvvBNx0=";
  };
  cargoHash = "sha256-E5AE18CfeX1HI/FbGDFoUDsPyG/CpJrD+8Ky7c+EQUw=";
  meta = {
    description = "Sxhkd clone for Wayland (works on TTY and X11 too)";
    homepage = "https://github.com/waycrate/swhkd";
    license = lib.licenses.bsd2;
    mainProgram = "swhkd";
  };
}
