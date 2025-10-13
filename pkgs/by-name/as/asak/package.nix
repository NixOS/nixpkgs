{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  installShellFiles,
  alsa-lib,
  libjack2,
}:

rustPlatform.buildRustPackage rec {
  pname = "asak";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "chaosprint";
    repo = "asak";
    tag = "v${version}";
    hash = "sha256-7r05sVIHqBBOKwye2fr0pspo/uDqaYGjt5CpxqgqKzI=";
  };

  cargoHash = "sha256-XoTfymCXrvoToSY7jw+Pn8Wm6fskFzl4f55uiKnSsJ8=";

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
    changelog = "https://github.com/chaosprint/asak/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "asak";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
