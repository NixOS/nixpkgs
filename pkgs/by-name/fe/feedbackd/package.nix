{
  lib,
  stdenv,
  fetchFromGitLab,
  testers,
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
  version = "0.8.9";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "feedbackd";
    repo = "feedbackd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4cbH5jzbLROs/FtbiktlyZPGPYiIo3wgqgOCzyzNzzs=";
  };

  postPatch = ''
    patchShebangs run.in

    substituteInPlace data/72-feedbackd.rules \
      --replace-fail '/usr/libexec/' "$out/libexec/"
  '';

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
    "-Dmedia-roles=true"
    # Make compiling work when doCheck = false
    "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
  ];

  nativeCheckInputs = [
    dbus
    umockdev
  ];

  doCheck = true;

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
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = nix-update-script { };
  };

  strictDeps = true;

  meta = {
    description = "Theme based Haptic, Visual and Audio Feedback";
    homepage = "https://gitlab.freedesktop.org/feedbackd/feedbackd/";
    license = with lib.licenses; [
      # feedbackd
      gpl3Plus

      # libfeedback library
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [
      pacman99
      Luflosi
    ];
    pkgConfigModules = [ "libfeedback-0.0" ];
    platforms = lib.platforms.linux;
  };
})
