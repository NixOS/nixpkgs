{ lib
, desktop-file-utils
, fetchFromGitLab
, gobject-introspection
, gtk4
, gtksourceview5
, libadwaita
, libspelling
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buffer";
  version = "0.9.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "cheywood";
    repo = "buffer";
    rev = finalAttrs.version;
    hash = "sha256-WhUSiZ2Nty5CdaJC8zZVkUptP5cRnMByZKy3e9TAyjs=";
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
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3.sitePackages}"
    )
  '';

  meta = with lib; {
    description = "Minimal editing space for all those things that don't need keeping";
    homepage = "https://gitlab.gnome.org/cheywood/buffer";
    license = licenses.gpl3Plus;
    mainProgram = "buffer";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.linux;
  };
})
