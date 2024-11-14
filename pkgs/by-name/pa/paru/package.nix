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
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "paru";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Morganamilo";
    repo = "paru";
    rev = "v${version}";
    hash = "sha256-VFIeDsIuPbWGf+vio5i8qGUBB+spP/7SwYwmQkMjtL8=";
  };

  cargoPatches = [
    ./cargo-lock.patch
  ];

  cargoHash = "sha256-z8hYZu/3RV99hOTpnv4ExgXymhzuITDcGjJhcHLWcH8=";

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

  # https://github.com/Morganamilo/paru/issues/1154#issuecomment-2002357898
  buildFeatures = lib.optionals stdenv.hostPlatform.isAarch64 [
    "generate"
  ];

  postBuild = ''
    sh ./scripts/mkmo locale/
  '';

  postInstall = ''
    installManPage man/paru.8 man/paru.conf.5
    installShellCompletion --bash completions/bash
    installShellCompletion --fish completions/fish
    installShellCompletion --zsh completions/zsh
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
