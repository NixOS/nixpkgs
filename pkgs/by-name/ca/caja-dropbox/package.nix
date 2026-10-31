{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  pkg-config,
  gobject-introspection,
  gdk-pixbuf,
  caja,
  gtk3,
  python3,
  dropbox,
  gitUpdater,
}:

let
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "caja-dropbox";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/caja-dropbox-${finalAttrs.version}.tar.xz";
    sha256 = "t0w4qZQlS9PPfLxxK8LsdRagypQqpleFJs29aqYgGWM=";
  };

  patches = [
    (replaceVars ./fix-cli-paths.patch {
      inherit dropboxd;
      # patch context
      DESKTOP_FILE_DIR = null;
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    gdk-pixbuf
    (python3.withPackages (
      ps: with ps; [
        docutils
        pygobject3
      ]
    ))
  ];

  buildInputs = [
    caja
    gtk3
    python3
  ];

  configureFlags = [ "--with-caja-extension-dir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/caja-dropbox";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Dropbox extension for Caja file manager";
    homepage = "https://github.com/mate-desktop/caja-dropbox";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-nd-30
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
