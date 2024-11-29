{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libevdev,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "evremap";
  version = "0-unstable-2024-06-17";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "evremap";
    rev = "cc618e8b973f5c6f66682d1477b3b868a768c545";
    hash = "sha256-aAAnlGlSFPOK3h8UuAOlFyrKTEuzbyh613IiPE7xWaA=";
  };

  cargoHash = "sha256-uFej58+51+JX36K1Rr1ZmBe7rHojOjmTO2VWINS6MvU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevdev ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Keyboard input remapper for Linux/Wayland systems";
    homepage = "https://github.com/wez/evremap";
    maintainers = with lib.maintainers; [ pluiedev ];
    license = with lib.licenses; [ mit ];
    mainProgram = "evremap";
  };
}
