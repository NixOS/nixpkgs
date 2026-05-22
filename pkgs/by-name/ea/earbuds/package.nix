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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "earbuds";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "JojiiOfficial";
    repo = "LiveBudsCli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x0PXOWj77VgJDPY4j+1PRg0M7+vIYSk+6yfj8s0UKx8=";
  };

  cargoHash = "sha256-N0/VtqulNRsuoiKcw1LMWTpYNLfX9IiU+hSDlm3ZP1Y=";

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
})
