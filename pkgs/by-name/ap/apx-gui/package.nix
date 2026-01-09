{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
  apx,
  gnome-console,
  vte-gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apx-gui";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y2Xrb0+vohfOZTlauk9o4nISwLz6/u87+dXBr3UqwH4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    (python3.withPackages (ps: [
      ps.pygobject3
      ps.pyyaml
      ps.requests
    ]))
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    vte-gtk4
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          apx
          gnome-console
        ]
      }"
    )
  '';

  meta = {
    description = "GUI frontend for Apx in GTK 4 and Libadwaita";
    homepage = "https://github.com/Vanilla-OS/apx-gui";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chewblacka ];
    mainProgram = "apx-gui";
  };
})
