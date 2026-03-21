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
  shaderc,
  libglvnd,
  vulkan-loader,
  autoPatchelfHook,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jay";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "jay";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mm2bXxl9TaKwmeCwFz3IKznqjsfY8RKEVU/RK4zd63U=";
  };

  cargoHash = "sha256-T7053eAH3IqkAxNZpYHdC6Z7JZtArrOqGMjoIccjemI=";

  env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

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
    shaderc
  ];

  runtimeDependencies = [
    libglvnd
    vulkan-loader
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
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
})
