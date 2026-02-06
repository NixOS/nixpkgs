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
  version = "2.1.0-unstable-2026-01-09";

  src = fetchFromGitHub {
    owner = "Morganamilo";
    repo = "paru";
    rev = "9ac3578807a87858651e81a02586ceb947686e7c";
    hash = "sha256-TJbhxVnP5UhlCmwxKjXq/XaqPGtzHoN5S+lizm3Bmvs=";
  };

  cargoHash = "sha256-Shp/2jQtO3pulT2gmsAcsEVPpv76nbEiGol+kYD7kr8=";

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
