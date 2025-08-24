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
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "kirottu";
    repo = "anyrun";
    rev = "bed987ed5dec0b29865b973ad4fce04c5da2ea21";
    hash = "sha256-2iAIrSC4ubTCEM5BeC+R7dywkj9CAV0K6vHbqxCcCtA=";
  };

  cargoHash = "sha256-n+UJzx80JAQ4hqdk7OjyvSsCYql9I6yKLA5ab9iS9vQ=";

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
