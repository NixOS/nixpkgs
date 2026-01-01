{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
<<<<<<< HEAD
  anyrun-provider,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "25.12.0";
=======
  version = "25.9.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "anyrun-org";
    repo = "anyrun";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-KEEJLERvo04AsPo/SWHFJUmHaGGOVjUoGwA9e8GVIQQ=";
  };

  cargoHash = "sha256-IDrDgmksDdKw5JYY/kw+CCEIDJ6S2KARxUDSul713pw=";
=======
    hash = "sha256-IlnFA/a9Clgbt+FuavIKWtauhtH4Fo/rGJIjJDDeYRs=";
  };

  cargoHash = "sha256-gP324zqfoNSYKIuTJFTWRr2fKBreVZFfZNR+jUasp/8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
     --prefix PATH ":" ${lib.makeBinPath [ anyrun-provider ]}
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
     --prefix ANYRUN_PLUGINS : $out/lib
    )
  '';

  postInstall = ''
    install -Dm444 anyrun/res/style.css examples/config.ron -t $out/share/doc/anyrun/examples/
  '';

<<<<<<< HEAD
  passthru = {
    updateScript = nix-update-script { };
    # This is used for detecting whether or not an Anyrun package has the provider
    inherit anyrun-provider;
  };
=======
  passthru.updateScript = nix-update-script { };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
