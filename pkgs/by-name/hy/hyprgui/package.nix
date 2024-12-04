{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  cairo,
  gtk4,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprgui";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bg1S/FhduRSSXc3Yd7SkyrmMKff7oh0jw781jTB0J60=";
  };

  cargoHash = "sha256-bhtmU0vGptUYrPN/BbbSvSa27Ykma8UI6TS17eiQkyU=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    cairo
    pango
    gtk4
  ];

  postInstall = ''
    install -Dm644 -t $out/usr/share/icons hyprgui.png
    install -Dm644 -t $out/usr/share/applications hyprgui.desktop
  '';

  meta = {
    description = "GUI for configuring Hyprland written in Rust";
    homepage = "https://github.com/hyprutils/hyprgui";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fccapria ];
    badPlatforms = lib.platforms.darwin;
    mainProgram = "hyprgui";
  };
}
