{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
  wayland,
  gtk-layer-shell,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "anyrun";
  version = "0-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "kirottu";
    repo = "anyrun";
    rev = "d2017f224b2bfd7e33573c7070e7c3e2960c7dcc";
    hash = "sha256-L1hLXf4IDZ0KoXbFiSNNZJ7IrReEr/J+CLt6Rl4Ea3M=";
  };

  cargoHash = "sha256-DgUNSRr2Hs+GeYeR2ex8WiwotmT12G1cjSvQVK2py3c=";

  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    gtk-layer-shell
    pango
    wayland
  ];

  preFixup = ''
    gappsWrapperArgs+=(
     --prefix ANYRUN_PLUGINS : $out/lib
    )
  '';

  postInstall = ''
    install -Dm444 anyrun/res/style.css examples/config.ron -t $out/share/doc/anyrun/examples/
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wayland-native, highly customizable runner";
    homepage = "https://github.com/kirottu/anyrun";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      khaneliman
      NotAShelf
    ];
    mainProgram = "anyrun";
    platforms = lib.platforms.linux;
  };
}
