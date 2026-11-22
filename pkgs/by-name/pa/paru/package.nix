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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paru";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Morganamilo";
    repo = "paru";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0V8v0Er+8Hs9HjnLsTfzkmQ7pYxw/2rMtN78MK6piMg=";
  };

  cargoHash = "sha256-BecGagGsapbvnYuX+arSKwgIxzVXU+CGWoy+YMyA8VU=";

  postPatch = ''
    substituteInPlace tests/startup.rs \
      --replace-fail "/bin/cat" "cat"
  '';

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
    changelog = "https://github.com/Morganamilo/paru/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wegank ];
    mainProgram = "paru";
    platforms = lib.platforms.linux;
  };
})
