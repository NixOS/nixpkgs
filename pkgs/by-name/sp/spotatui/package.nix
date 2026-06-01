{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  alsa-lib,
  openssl,
  pipewire,

  withPipewireVisualizer ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spotatui";
  version = "0.38.3";

  src = fetchFromGitHub {
    owner = "LargeModGames";
    repo = "spotatui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ul4+CI+tPkFTEjVzw8tivpEqiBn28SRVEui1uM2Jq2E=";
  };

  cargoHash = "sha256-sdQsr5Z8zvKdrPQRTVsuJJqHPHSJOdTFzvoHx41AT6s=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optional withPipewireVisualizer rustPlatform.bindgenHook;

  buildInputs = [
    alsa-lib
    openssl
  ]
  ++ lib.optional withPipewireVisualizer pipewire;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "discord-rpc"
    "mpris"
    "streaming"
    "telemetry"
  ]
  ++ lib.optional withPipewireVisualizer "audio-viz";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fully standalone Spotify client for the terminal";
    homepage = "https://github.com/LargeModGames/spotatui";
    changelog = "https://github.com/LargeModGames/spotatui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lordmzte ];
    mainProgram = "spotatui";

    # macOS is supported by upstream, but the package maintainer has no way to test this.
    platforms = lib.platforms.linux;
  };
})
