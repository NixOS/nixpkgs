{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gettext,
  installShellFiles,
  pkg-config,
  libarchive,
  openssl,
  pacman,
}:

rustPlatform.buildRustPackage rec {
  pname = "paru";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Morganamilo";
    repo = "paru";
    tag = "v${version}";
    hash = "sha256-i99f2ngYhfVCKpImJ8L7u2T2FgOt7Chp8DHDbrNh1kw=";
  };

  cargoHash = "sha256-USIceRh24WGV0TIrpuyHs4thjaghpxqZmk2uVKBxlm4=";

  nativeBuildInputs = [
    gettext
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libarchive
    openssl
    pacman
  ];

  postBuild = ''
    sh ./scripts/mkmo locale/
  '';

  postInstall = ''
    installManPage man/paru.8 man/paru.conf.5
    installShellCompletion --name paru.bash --bash completions/bash
    installShellCompletion --name paru.fish --fish completions/fish
    installShellCompletion --name _paru --zsh completions/zsh
    cp -r locale "$out/share/"
  '';

  meta = {
    description = "Feature packed AUR helper";
    homepage = "https://github.com/Morganamilo/paru";
    changelog = "https://github.com/Morganamilo/paru/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wegank ];
    mainProgram = "paru";
    platforms = lib.platforms.linux;
  };
}
