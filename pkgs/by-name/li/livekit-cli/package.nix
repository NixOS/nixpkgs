{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  pkg-config,
  portaudio,
}:

buildGoModule (finalAttrs: {
  pname = "livekit-cli";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NBthUtUoxF8eXic6yT9T5hwLGQz2p8TwOrxdUKBM8qE=";
  };

  vendorHash = "sha256-EynBsQg+eA6qX4sPIwKIFpPD6utxvY4VA6G4wxDNjK8=";

  # Use nixpkgs portaudio package + pkg-config rather than relying on a vendored
  # git submodule, similar to the homebrew solution
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ portaudio ];
  tags = [ "portaudio_system" ];

  subPackages = [ "cmd/lk" ];

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mgdelacroix
      faukah
      carschandler
    ];
    mainProgram = "lk";
  };
})
