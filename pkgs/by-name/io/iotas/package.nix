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
  version = "0.9.5";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "iotas";
    rev = version;
    hash = "sha256-SDapnAGPTi7tnzl3zeNJw2CABhVVAXMyn1bllg8fChw=";
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
    strenum
    packaging
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Simple note taking with mobile-first design and Nextcloud sync";
    homepage = "https://gitlab.gnome.org/World/iotas";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "iotas";
    maintainers = with lib.maintainers; [ zendo ];
  };
}
