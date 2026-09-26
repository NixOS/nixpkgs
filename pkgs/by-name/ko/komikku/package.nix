{
  lib,
  fetchFromCodeberg,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  glib,
  glib-networking,
  gnome,
  gobject-introspection,
  gtk4,
  gtksourceview5,
  libadwaita,
  libglycin,
  librsvg,
  meson,
  ninja,
  pkg-config,
  python3,
  webkitgtk_6_0,
  webp-pixbuf-loader,
  wrapGAppsHook4,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "komikku";
  version = "51.0.0";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "valos";
    repo = "Komikku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5YEvYdkktoIEWoyTLop4tNVxG69/qPneOO0i0nW/Tfg=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gettext
    glib # for glib-compile-resources
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glib-networking
    gtk4
    gtksourceview5
    libadwaita
    libglycin
    webkitgtk_6_0
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    brotli
    colorthief
    curl-cffi
    dateparser
    ebooklib
    emoji
    jxlpy
    keyring
    lxml
    natsort
    piexif
    pillow
    pygobject3
    pyjwt
    pypdf
    pytesseract
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
    changelog = "https://codeberg.org/valos/Komikku/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      chuangzhu
      Gliczy
    ];
    teams = [ lib.teams.gnome-circle ];
  };
})
