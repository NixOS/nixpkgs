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
  feedbackd-device-themes,
  udevCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "feedbackd";
  version = "0.8.5";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "agx";
    repo = "feedbackd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m8jDn7gDrZOsdFl17IsIINgcpuHmmtNOCEEdQFwVj6g=";
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
    udevCheckHook
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

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  strictDeps = true;

  meta = with lib; {
    description = "Theme based Haptic, Visual and Audio Feedback";
    homepage = "https://gitlab.freedesktop.org/agx/feedbackd/";
    license = with licenses; [
      # feedbackd
      gpl3Plus

      # libfeedback library
      lgpl21Plus
    ];
    maintainers = with maintainers; [
      pacman99
      Luflosi
    ];
    platforms = platforms.linux;
  };
})
