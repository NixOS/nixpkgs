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
  version = "25.9.0.pre-release.1-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "anyrun-org";
    repo = "anyrun";
    rev = "af1ffe4f17921825ff2a773995604dce2b2df3cd";
    hash = "sha256-PKxVhfjd2AlzTopuVEx5DJMC4R7LnM5NIoMmirKMsKI=";
  };

  cargoHash = "sha256-KpAnfytTtCJunhpk9exv8LYtF8mKDGFUUbsPP47M+Kk=";

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
    homepage = "https://github.com/anyrun-org/anyrun";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      khaneliman
      NotAShelf
    ];
    mainProgram = "anyrun";
    platforms = lib.platforms.linux;
  };
}
