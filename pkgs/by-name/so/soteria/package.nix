{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  nix-update-script,
  cairo,
  gdk-pixbuf,
  gettext,
  glib,
  gtk4,
  pango,
  polkit,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "soteria";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "imvaskel";
    repo = "soteria";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g6DGb8PWfc5YyjUpO9q3q0MxcPUbMjatOi6POFcZEE4=";
  };

  cargoHash = "sha256-6Pk60J2RAInRgCiIk9thZRwwAyCQvychh5nVHmKU7Iw=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gettext
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    pango
  ];

  preBuild = ''
    export SOTERIA_DEFAULT_LOCALE_DIR=$out/share/locale
  '';

  postInstall = ''
    mkdir -p $SOTERIA_DEFAULT_LOCALE_DIR
    for file in po/*.po; do
      lang=''${file%.*}
      lang=''${lang#po/}
      mkdir -p "$SOTERIA_DEFAULT_LOCALE_DIR/$lang/LC_MESSAGES"
      msgfmt "$file" -o "$SOTERIA_DEFAULT_LOCALE_DIR/$lang/LC_MESSAGES/soteria.mo"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Polkit authentication agent written in GTK designed to be used with any desktop environment";
    homepage = "https://github.com/ImVaskel/soteria";
    license = lib.licenses.asl20;
    mainProgram = "soteria";
    maintainers = with lib.maintainers; [
      NotAShelf
    ];
    inherit (polkit.meta) platforms;
  };
})
