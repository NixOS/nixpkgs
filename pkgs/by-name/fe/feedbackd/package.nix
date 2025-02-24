{
  lib,
  stdenv,
  fetchFromGitLab,
  docbook-xsl-nons,
  docutils,
  gi-docgen,
  gobject-introspection,
  gtk-doc,
  libxslt,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  glib,
  gsound,
  json-glib,
  libgudev,
  dbus,
  gmobile,
  umockdev,
}:

let
  themes = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd-device-themes";
    rev = "v0.4.0";
    hash = "sha256-kY/+DyRxKEUzq7ctl6Va14AKUCpWU7NRQhJOwhtkJp8=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "feedbackd";
  version = "0.4.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ta14DYqkid8Cp8fx9ZMGOOJroCBszN9/VrTN6mrpTZg=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    docutils # for rst2man
    gi-docgen
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
    gmobile
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dman=true"
    # Make compiling work when doCheck = false
    "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
  ];

  nativeCheckInputs = [
    dbus
    umockdev
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/data/90-feedbackd.rules > $out/lib/udev/rules.d/90-feedbackd.rules
    cp ${themes}/data/* $out/share/feedbackd/themes/
  '';

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    if [[ -d "$out/share/doc" ]]; then
        find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
          | while IFS= read -r -d ''' file; do
            moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
        done
    fi
  '';

  meta = with lib; {
    description = "Daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.linux;
  };
})
