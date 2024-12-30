{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  makeBinaryWrapper,

  gtk4,
  libadwaita,
  glib,
  libgee,
  wrapGAppsHook4,

  mangohud,
  mesa-demos,
  vulkan-tools,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mangojuice";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "radiolamp";
    repo = "mangojuice";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-EWpXikyO7N2NjONqnTx8+9w16Pt5ne7qX67bYirShjc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib # For glib-compile-schemas
    vala
    pkg-config
    makeBinaryWrapper
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    libgee
  ];

  strictDeps = true;
  dontWrapGApps = true;

  postFixup =
    let
      path = lib.makeBinPath [
        mangohud
        mesa-demos
        vulkan-tools
      ];
    in
    ''
      wrapProgram $out/bin/mangojuice \
        --prefix PATH : ${path} \
        "''${gappsWrapperArgs[@]}"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convenient alternative to GOverlay for setting up MangoHud";
    homepage = "https://github.com/radiolamp/mangojuice";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pluiedev
      getchoo
    ];
  };
})
