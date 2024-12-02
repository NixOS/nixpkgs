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
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-VP+6qWu4nv8h9LLjTnl8Mh1aAlIA+zuufRYoouxl2Tc=";
  };

  cargoHash = "sha256-t0HqraCA4q7K4EEtPS8J0ZmnhBB+Zf0aX+yXSUdKJzo=";

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
