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
  version = "0-unstable-2025-05-27";

  src = fetchFromGitHub {
    owner = "kirottu";
    repo = "anyrun";
    rev = "25367153f225a59c5ce5746583e39a71ff052f09";
    hash = "sha256-pg0w4uOZI32dLASD6UbBezeQg5PwOa0GLv7rTwn3VxY=";
  };

  cargoHash = "sha256-ouAeoSCmkvWgxAUA/VYITm9/XvxmN+TdyZgEGgBGdKI=";

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
