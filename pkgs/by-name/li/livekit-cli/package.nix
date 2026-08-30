{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  portaudio,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "livekit-cli";
  version = "2.18.2";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

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
