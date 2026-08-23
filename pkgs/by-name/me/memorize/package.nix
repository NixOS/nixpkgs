{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  swiftpm2nix,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  gdk-pixbuf,
  graphene,
  pango,
  cairo,
  desktop-file-utils,
  libxml2,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memorize";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "david-swift";
    repo = "Memorize";
    rev = finalAttrs.version;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gdk-pixbuf
    graphene
    pango
    cairo
    libxml2
    swift
  ];

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    install -Dm755 "$binPath/Memorize" "$out/bin/memorize"

    install -Dm644 \
      data/icons/io.github.david_swift.Flashcards.svg \
      "$out/share/icons/hicolor/scalable/apps/io.github.david_swift.Flashcards.svg"

    local metainfo="data/io.github.david_swift.Flashcards.metainfo.xml"
    if [ -f "$metainfo" ]; then
      install -Dm644 "$metainfo" \
        "$out/share/metainfo/io.github.david_swift.Flashcards.metainfo.xml"
    fi

    local desktop="data/io.github.david_swift.Flashcards.desktop"
    if [ -f "$desktop" ]; then
      install -Dm644 "$desktop" \
        "$out/share/applications/io.github.david_swift.Flashcards.desktop"
    fi

    local schema
    for schema in data/io.github.david_swift.Flashcards.gschema.xml \
                  data/*.gschema.xml; do
      [ -f "$schema" ] || continue
      install -Dm644 "$schema" \
        "$out/share/glib-2.0/schemas/$(basename "$schema")"
    done

    runHook postInstall
  '';

  postInstall = ''
    if ls "$out/share/glib-2.0/schemas/"*.gschema.xml &>/dev/null; then
      ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas/"
    fi
  '';

  meta = {
    description = "Study flashcards in a native GNOME app";
    homepage = "https://github.com/david-swift/Memorize";
    changelog = "https://github.com/david-swift/Memorize/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.onny ];
    platforms = lib.platforms.linux;
    mainProgram = "memorize";
  };
})
