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
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "Satty-org";
    repo = "Satty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-76J4ZlBKeow2sWs1SeSkE8R2fKRTFD+B+7Vx3nbbQxY=";
  };

  cargoHash = "sha256-R8I8eZ8vy6w1DGNrkP9Os2tAOIetqXCyn0cxWpk9F+w=";

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
    homepage = "https://github.com/Satty-org/Satty";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      pinpox
      donovanglover
    ];
    mainProgram = "satty";
    platforms = lib.platforms.linux;
  };
})
