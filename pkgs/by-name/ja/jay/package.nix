{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libGL,
  libinput,
  pkgconf,
  xkeyboard_config,
  libgbm,
  pango,
  udev,
  libglvnd,
  vulkan-loader,
  autoPatchelfHook,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jay";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "jay";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tC2V1BgUGsUMpZsKXjFSS8Mp28LrNI/QNu761zpgAkc=";
  };

  cargoHash = "sha256-96vCkZR/8dgZH0hJPeKzP7jQZ41W7XTi9yMnxFaIhoY=";

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    pkgconf
  ];

  buildInputs = [
    libGL
    xkeyboard_config
    libgbm
    pango
    udev
    libinput
  ];

  runtimeDependencies = [
    libglvnd
    vulkan-loader
  ];

  checkFlags = [
    # these 5 tests fail in the lix sandbox because they rely on io_uring
    "--skip=cpu_worker::tests::cancel"
    "--skip=cpu_worker::tests::complete"
    "--skip=eventfd_cache::tests::test"
    "--skip=io_uring::ops::read_write_no_cancel::tests::cancel_in_kernel"
    "--skip=io_uring::ops::read_write_no_cancel::tests::cancel_in_userspace"
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
