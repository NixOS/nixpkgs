{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  bluez,
  dbus,
  libpulseaudio,
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

  cargoHash = "sha256-Y1pMmWxfXGcEFPj05/BpXQvd199O5l6hJmePNxMQc/Y=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    bluez
    dbus
    libpulseaudio
  ];

  # package does not contain any tests
  doCheck = false;

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
