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
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "gabm";
    repo = "Satty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pR3Mc5Eue4YcIMcrzkyDhZPpovRFa8TW1PjL/ysH/7s=";
  };

  cargoHash = "sha256-/WewpLpBmD4XnjwY7NmzbglYGNKmgMLjg1pvUdqEIwo=";

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
