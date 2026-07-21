{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  libepoxy,
  libGL,
  copyDesktopItems,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {

  pname = "satty";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "gabm";
    repo = "Satty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pD91+MbieZ5/YoUR0lcKnJ9bA1fn7I97NbnIwm/kL7E=";
  };

  cargoHash = "sha256-Oavfb2Jp9WO0eaT5TqRwSxU3+rm9lBxwuWTWnc2CnZ0=";

  # Generate shell completions and man file
  buildFeatures = [ "ci-release" ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook4
    installShellFiles
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libepoxy
    libGL
  ];

  postInstall = ''
    install -Dt $out/share/icons/hicolor/scalable/apps/ assets/satty.svg

    installShellCompletion --cmd satty \
      --bash completions/satty.bash \
      --fish completions/satty.fish \
      --zsh completions/_satty
  '';

  desktopItems = [ "satty.desktop" ];

  meta = {
    description = "Screenshot annotation tool inspired by Swappy and Flameshot";
    homepage = "https://github.com/gabm/Satty";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      pinpox
      donovanglover
    ];
    mainProgram = "satty";
    platforms = lib.platforms.linux;
  };
})
