{
  lib,
  python3Packages,
  fetchFromGitLab,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  glib,
  gtk4,
  librsvg,
  libsecret,
  libadwaita,
  gtksourceview5,
  webkitgtk_6_0,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "iotas";
  version = "2026.7";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "iotas";
    tag = finalAttrs.version;
    hash = "sha256-qJI1C5G8DGdIOHXVPiky7JK+Re+0WY18c868LY8/h4k=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libsecret
    libadwaita
    gtksourceview5
    webkitgtk_6_0
  ];

  dependencies = with python3Packages; [
    pygobject3
    pygtkspellcheck
    requests
    markdown-it-py
    linkify-it-py
    mdit-py-plugins
    pypandoc
    packaging
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    changelog = "https://gitlab.gnome.org/World/iotas/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Simple note taking with mobile-first design and Nextcloud sync";
    homepage = "https://gitlab.gnome.org/World/iotas";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "iotas";
    maintainers = with lib.maintainers; [ zendo ];
    teams = [ lib.teams.gnome-circle ];
  };
})
