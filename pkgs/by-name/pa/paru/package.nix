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

let
  # only libalpm v14.x.x is supported
  pacman_6 = pacman.overrideAttrs (previousAttrs: {
    version = "6.1.0";
    src = previousAttrs.src.overrideAttrs {
      outputHash = "sha256-uHBq1A//YSqFATlyqjC5ZgmvPkNKqp7sVew+nbmLH78=";
    };
    hardeningDisable = [ "fortify3" ];
  });
in
rustPlatform.buildRustPackage rec {
  pname = "paru";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "Morganamilo";
    repo = "paru";
    rev = "v${version}";
    hash = "sha256-0+N1WkjHd2DREoS1pImXXvlJ3wXoXEBxFBtupjXqyP8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alpm-3.0.4" = "sha256-cfIOCUyb+kDAT3Bn50oKuJzIyMyeFyOPBFQMkAgMocI=";
      "aur-depends-3.0.0" = "sha256-Z/vCd4g3ic29vC0DXFHTT167xFAXYxzO2YQc0XQOerE=";
    };
  };

  nativeBuildInputs = [
    gettext
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libarchive
    openssl
    pacman_6
  ];

  # https://aur.archlinux.org/packages/paru#comment-961914
  buildFeatures = lib.optionals stdenv.isAarch64 [ "generate" ];

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
