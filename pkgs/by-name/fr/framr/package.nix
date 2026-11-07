{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  dbus,
  wayland,
  libxkbcommon,
  cairo,
  pango,
  libxcursor,
  mesa,
  libgbm,
  libdrm,
  ffmpeg,
  alsa-lib,
  pipewire,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framr";
  version = "0.17.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vMohammad24";
    repo = "framr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w3IUyWANnn8VTXFPyoyHiQRsozx6ML0kHlEyP3+QT18=";
  };

  cargoHash = "sha256-rUhATkJ0R066ljC0ybGG43xNKc+YRaav+n8YZDEhSXM=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    alsa-lib
    cairo
    dbus
    ffmpeg
    libdrm
    libgbm
    libxcursor
    libxkbcommon
    mesa
    pango
    pipewire
    wayland
  ];

  postInstall = ''
    install -Dm644 assets/framr-handler.desktop \
      $out/share/applications/framr-handler.desktop

    installShellCompletion --cmd framr \
      --bash <($out/bin/framr completions bash) \
      --zsh <($out/bin/framr completions zsh) \
      --fish <($out/bin/framr completions fish)

    $out/bin/framr man man-pages
    installManPage man-pages/*.1
  '';

  meta = {
    description = "Wayland screenshot, annotation and screen recording tool with ShareX-compatible uploads";
    homepage = "https://github.com/vMohammad24/framr";
    changelog = "https://github.com/vMohammad24/framr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ vmohammad ];
    mainProgram = "framr";
    platforms = lib.platforms.linux;
  };
})
