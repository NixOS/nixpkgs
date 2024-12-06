{
  lib,
  fetchFromGitea,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  blueprint-compiler,
  gtk4,
  libadwaita,
  libnotify,
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
  version = "1.65.0";

  format = "other";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
    hash = "sha256-U+ekx6ON3mLaTqaQ6PYe9bGVWMyq9PXZyv+rQ1cd1n0=";
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
    gtk4
    libadwaita
    libnotify
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    brotli
    colorthief
    dateparser
    emoji
    keyring
    lxml
    natsort
    piexif
    pillow
    pillow-heif
    curl-cffi
    pygobject3
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

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

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
  };
}
