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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "chaosprint";
    repo = "asak";
    tag = "v${version}";
    hash = "sha256-Kq1WdVcTRdz6vJxUDd0bqb2bfrNGCl611upwYploR7w=";
  };

  cargoHash = "sha256-SS4BDhORiTV/HZhL3F9zwF8oBu/VFVYhF5Jzp2j0QFI=";

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
