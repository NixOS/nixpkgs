{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkg-config,
  dbus,
  libpulseaudio,
  bluez,
}:
rustPlatform.buildRustPackage {
  pname = "earbuds";
  version = "0.1.9-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "JojiiOfficial";
    repo = "LiveBudsCli";
    rev = "df46706e44fa9e7de355b11eab4cc850efe968a3";
    hash = "sha256-IEor7aZnwCA6Rg2gXIYSQ65hV/jJOKehujOSZnVzVis=";
  };

  # fix daemon autostart not working
  patches = [
    ./fix-daemon.patch
  ];

  # git dependencies are currently not supported in the fixed-output derivation fetcher.
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "galaxy_buds_rs-0.2.10" = "sha256-95PBmGwHJiXi72Rir8KK7as+i9yjs5nf45SaBhj1geg=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    dbus
    libpulseaudio
    bluez
  ];

  # package does not contain any tests
  doCheck = false;

  # nativeInstallCheckInputs = [
  #   versionCheckHook
  # ];
  # versionCheckProgramArg = [ "--version" ];
  # doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd earbuds \
      --bash <($out/bin/earbuds --generate bash) \
      --fish <($out/bin/earbuds --generate fish) \
      --zsh <($out/bin/earbuds --generate zsh)
  '';

  meta = {
    description = "Free CLI tool to control your Galaxy Buds";
    homepage = "https://github.com/JojiiOfficial/LiveBudsCli";
    changelog = "https://github.com/JojiiOfficial/LiveBudsCli/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ griffi-gh ];
    mainProgram = "earbuds";
    platforms = lib.platforms.linux;
  };
}
