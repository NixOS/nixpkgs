{
  lib,
  desktop-file-utils,
  fetchFromGitLab,
  gobject-introspection,
  gtk4,
  gtksourceview5,
  libadwaita,
  libspelling,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buffer";
  version = "0.9.10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "cheywood";
    repo = "buffer";
    tag = finalAttrs.version;
    hash = "sha256-amWfrZX1b1OmLhL7w8j/+iEwYRnO1DVR580pLkjtS/g=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libspelling
    (python3.withPackages (
      ps: with ps; [
        pygobject3
      ]
    ))
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3.sitePackages}"
    )
  '';

  meta = {
    description = "Minimal editing space for all those things that don't need keeping";
    homepage = "https://gitlab.gnome.org/cheywood/buffer";
    license = lib.licenses.gpl3Plus;
    mainProgram = "buffer";
    maintainers = with lib.maintainers; [ michaelgrahamevans ];
    platforms = lib.platforms.linux;
  };
})
