{
  autoPatchelfHook,
  cairo,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  libgee,
  libnotify,
  nix-update-script,
  pkg-config,
  python3,
  sqlite,
  stdenv,
  vala,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xmlbird,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "birdfont";
  version = "2.33.6";

  src = fetchFromGitHub {
    owner = "johanmattssonm";
    repo = "birdfont";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7xVjY/yH7pMlUBpQc5Gb4t4My24Mx5KkARVp2KSr+Iw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gobject-introspection
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];
  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libgee
    libnotify
    sqlite
    webkitgtk_4_1
    xmlbird
  ];

  postPatch = ''
    substituteInPlace install.py \
      --replace-fail 'platform.version()' '"Nix"'

    patchShebangs .
  '';

  # workaround gcc >= 14 incompatibilities
  env.NIX_CFLAGS_COMPILE = "-std=gnu17 -Wno-error=incompatible-pointer-types";

  buildPhase = "./build.py";

  installPhase = "./install.py";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = lib.licenses.gpl3Plus;
    mainProgram = "birdfont";
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
