{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  anyrun-provider,
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
  version = "25.12.0";

  src = fetchFromGitHub {
    owner = "anyrun-org";
    repo = "anyrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KEEJLERvo04AsPo/SWHFJUmHaGGOVjUoGwA9e8GVIQQ=";
  };

  cargoHash = "sha256-IDrDgmksDdKw5JYY/kw+CCEIDJ6S2KARxUDSul713pw=";

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
     --prefix PATH ":" ${lib.makeBinPath [ anyrun-provider ]}
     --prefix ANYRUN_PLUGINS : $out/lib
    )
  '';

  postInstall = ''
    install -Dm444 anyrun/res/style.css examples/config.ron -t $out/share/doc/anyrun/examples/
  '';

  passthru = {
    updateScript = nix-update-script { };
    # This is used for detecting whether or not an Anyrun package has the provider
    inherit anyrun-provider;
  };

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
