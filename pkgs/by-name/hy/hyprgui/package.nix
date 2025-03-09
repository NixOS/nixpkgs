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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-akV83bvPuSJUleP0mDcnAR1KFegOXyoKSD0CVyNDJmc=";
  };

  cargoHash = "sha256-SBI2Gk4FImGw8169xIV8L0fbfcKzn6PqvLg6XxbpurI=";

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

  prePatch = ''
    substituteInPlace hyprgui.desktop \
    --replace-fail "/usr/bin/" ""
  '';

  postInstall = ''
    install -Dm644 -t $out/usr/share/icons hyprgui.png
    install -Dm644 -t $out/usr/share/applications hyprgui.desktop
    install -Dm644 -t $out/usr/share/licenses/${pname} LICENSE
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
