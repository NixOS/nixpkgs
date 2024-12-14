{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
    sha256 = "sha256-aNU4Ik033+kl9ZPHFzaAXZ6Hs+b7m5s0lpr1oovmWm0=";
  };

  cargoHash = "sha256-6sr0PU/Gb3CZ+RzvnEcu/v/F3PMyednCEk5wPSvwgmQ=";

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
}
