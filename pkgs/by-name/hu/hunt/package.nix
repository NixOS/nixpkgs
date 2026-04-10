{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hunt";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-aNU4Ik033+kl9ZPHFzaAXZ6Hs+b7m5s0lpr1oovmWm0=";
  };

  cargoHash = "sha256-rf/aBxuiv6c0cUJcFTCYoQPIEwCfhQQZqVSk0BxSzfQ=";

  meta = {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
})
