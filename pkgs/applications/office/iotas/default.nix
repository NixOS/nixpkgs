{
  lib,
  python3,
  fetchFromGitLab,
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

python3.pkgs.buildPythonApplication rec {
  pname = "iotas";
  version = "0.2.10";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "iotas";
    rev = version;
    hash = "sha256-aITt+TJb/LrVOyb/mAC7U6/NJ4stHD76jjBFC7Pt7fU=";
  };

  nativeBuildInputs = [
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

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pygtkspellcheck
    requests
    markdown-it-py
    linkify-it-py
    mdit-py-plugins
    pypandoc
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Simple note taking with mobile-first design and Nextcloud sync";
    homepage = "https://gitlab.gnome.org/World/iotas";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "iotas";
    maintainers = with maintainers; [ zendo ];
  };
}
