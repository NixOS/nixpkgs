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
  version = "2.18.5";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zZlkBz9jXO2eSNf/c6dqSNgiAbtFiU+B4Th9rxOISGw=";
  };

  vendorHash = "sha256-iurI0XZcsQ6TFmjM2mmPrx2ZYBW4NdQgmW8g72oqzww=";

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
