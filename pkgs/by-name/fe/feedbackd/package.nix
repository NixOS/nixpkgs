{
  lib,
  callPackage,
  dbus,
  docbook-xsl-nons,
  docutils,
  fetchFromGitLab,
  gi-docgen,
  glib,
  gmobile,
  gobject-introspection,
  gsound,
  gtk-doc,
  json-glib,
  libgudev,
  libxslt,
  meson,
  ninja,
  pkg-config,
  stdenv,
  umockdev,
  vala,
  wrapGAppsHook3,
}:

let
  sources = callPackage ./sources.nix { };
  themes = sources.feedbackd-device-themes.src;
in
stdenv.mkDerivation {
  inherit (sources.feedbackd) pname version src;

  outputs = [
    "out"
    "man"
    "dev"
    "devdoc"
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    docbook-xsl-nons
    docutils # for rst2man
    gi-docgen
    gmobile
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    umockdev
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
  ];

  nativeCheckInputs = [ dbus ];

  mesonFlags = [
    (lib.mesonBool "gtk_doc" true)
    (lib.mesonBool "man" true)
  ];

  doCheck = true;

  strictDeps = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/data/90-feedbackd.rules > $out/lib/udev/rules.d/90-feedbackd.rules
    cp ${themes}/data/* $out/share/feedbackd/themes/
  '';

  # Move developer documentation to devdoc output.
  # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move
  # right back.
  postFixup = ''
    if [[ -d "$out/share/doc" ]]; then
        find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
          | while IFS= read -r -d ''' file; do
            moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
        done
    fi
  '';

  passthru = {
    inherit sources;
  };

  meta = {
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    description = "Daemon to provide haptic (and later more) feedback on events";
    license = lib.licenses.gpl3Plus;
    mainProgram = "fbcli";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
}
