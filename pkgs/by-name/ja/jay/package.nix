{
  lib,
  stdenv,
  rustPlatform,
  autoPatchelfHook,
  fetchFromGitHub,
  installShellFiles,
  libGL,
  libgbm,
  libglvnd,
  libinput,
  nix-update-script,
  pango,
  pkgconf,
  sqlite,
  udev,
  vulkan-loader,
  xkeyboard_config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jay";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "jay";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Fa3nQ0TQtYeTk0N/qSD4hO13BYddfEs9vxP49Rw++tU=";
  };

  cargoHash = "sha256-PkSD687FNYB0llWaul8sM8jBXQelKn4JZpcstUJobN0=";

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    pkgconf
  ];

  buildInputs = [
    libGL
    libgbm
    libinput
    pango
    sqlite
    udev
    vulkan-loader
    xkeyboard_config
  ];

  runtimeDependencies = [
    libglvnd
  ];

  checkFlags = [
    # these tests fail in the lix sandbox because they rely on io_uring
    "--skip=cpu_worker::tests::cancel"
    "--skip=cpu_worker::tests::complete"
    "--skip=eventfd_cache::tests::test"
    "--skip=io_uring::"
    "--skip=utils::client_trace::"
    "--skip=utils::cross_process_ring_buffer::"
  ];

  postInstall = ''
    install -D etc/jay.portal $out/share/xdg-desktop-portal/portals/jay.portal
    install -D etc/jay-portals.conf $out/share/xdg-desktop-portal/jay-portals.conf
    install -D etc/jay.desktop $out/share/wayland-sessions/jay.desktop
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jay \
      --bash <("$out/bin/jay" generate-completion bash) \
      --zsh <("$out/bin/jay" generate-completion zsh) \
      --fish <("$out/bin/jay" generate-completion fish)
  '';

  passthru = {
    updateScript = nix-update-script { };
    providedSessions = [ "jay" ];
  };

  meta = {
    description = "Wayland compositor written in Rust";
    homepage = "https://github.com/mahkoh/jay";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ uku3lig ];
    mainProgram = "jay";
  };
})
