{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  installShellFiles,
  alsa-lib,
  libjack2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asak";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chaosprint";
    repo = "asak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MLc4OYsArdOWmoAqh2XTi3yQjI1uE7VwvTQ5D0Z1rfI=";
  };

  cargoHash = "sha256-sWyMJLyRFYPjnnaKWidVRwgNFlJbhcTBkciwF53e758=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    alsa-lib
    libjack2
  ];

  postInstall = ''
    installManPage target/man/asak.1

    installShellCompletion --cmd asak \
      --bash target/completions/asak.bash \
      --fish target/completions/asak.fish \
      --zsh target/completions/_asak
  '';

  meta = {
    description = "Cross-platform audio recording/playback CLI tool with TUI, written in Rust";
    homepage = "https://github.com/chaosprint/asak";
    changelog = "https://github.com/chaosprint/asak/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "asak";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
