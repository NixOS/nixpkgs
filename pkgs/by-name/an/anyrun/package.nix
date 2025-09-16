{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  pango,
  wayland,
  gtk4-layer-shell,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anyrun";
  version = "25.9.2";

  src = fetchFromGitHub {
    owner = "anyrun-org";
    repo = "anyrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSB62Y9QboWMF1aX+KMHc+HkGOMcw4X6gFZu6mQXlgk=";
  };

  cargoHash = "sha256-8LTeRhjU0z06BSOhRKeEC7HssFv2lcM6dIJqfHpIo9w=";

  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    gtk4-layer-shell
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

  passthru.updateScript = nix-update-script { };

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
})
