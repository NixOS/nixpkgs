{
  lib,
  fetchFromCodeberg,
  desktop-file-utils,
  gettext,
  glib,
  glib-networking,
  gobject-introspection,
  blueprint-compiler,
  gtk4,
  libadwaita,
  libglycin,
  webkitgtk_6_0,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
  librsvg,
  gnome,
  webp-pixbuf-loader,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "komikku";
  version = "1.101.0";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "valos";
    repo = "Komikku";
    tag = "v${version}";
    hash = "sha256-sDhnG6d77erHO9HS0fL4Fl5qHbeyuLz2TFeic5zLJIE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    glib # for glib-compile-resources
    desktop-file-utils
    gobject-introspection
    blueprint-compiler
  ];

  buildInputs = [
    glib
    glib-networking
    gtk4
    libadwaita
    libglycin
    webkitgtk_6_0
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    brotli
    colorthief
    dateparser
    ebooklib
    emoji
    keyring
    lxml
    natsort
    piexif
    pillow
    curl-cffi
    pygobject3
    pyjwt
    pypdf
    python-magic
    rarfile
    requests
    unidecode
  ];

  # Tests require network
  doCheck = false;

  # Pull in WebP support for manga pics of some servers.
  # In postInstall to run before gappsWrapperArgsHook.
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  # Prevent double wrapping.
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manga reader for GNOME";
    mainProgram = "komikku";
    homepage = "https://apps.gnome.org/Komikku/";
    license = lib.licenses.gpl3Plus;
    changelog = "https://codeberg.org/valos/Komikku/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      chuangzhu
      Gliczy
    ];
    teams = [ lib.teams.gnome-circle ];
  };
}
