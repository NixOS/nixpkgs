{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  blueprint-compiler,
  wrapGAppsHook4,
  gettext,
  desktop-file-utils,
  appstream,
  glib,
  glib-networking,
  pkg-config,
  cmake,
  gtk4,
  python3,
  python3Packages,
  libadwaita,
  gobject-introspection,
  libsecret,
  gst_all_1,
  xdg-user-dirs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nocturne";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Nocturne";
    tag = finalAttrs.version;
    hash = "sha256-7B9wtuxfsF6brtLkIEeWII4IvXwdJHnZ1Wr3uLfoqHU=";
  };

  __structuredAttrs = true;

  dontUseCmakeConfigure = true;

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    gobject-introspection
    wrapGAppsHook4
    gettext # for msgfmt
    desktop-file-utils # for desktop-file-validate
    appstream
    glib
    pkg-config
    cmake
    gtk4
    python3
  ];

  buildInputs = [
    gtk4
    libadwaita
    libsecret
    python3
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  pythonDependencies = [
    python3Packages.pygobject3
    python3Packages.tinytag
    python3Packages.requests
    python3Packages.syncedlyrics
    python3Packages.pycairo
    python3Packages.colorthief
    python3Packages.favicon
    python3Packages.mpris-server
    python3Packages.pillow
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath finalAttrs.pythonDependencies}
    )
  '';

  meta = {
    description = "Adwaita Music Player and Library Manager";
    homepage = "https://jeffser.com/nocturne/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "nocturne";
    platforms = lib.platforms.linux;
  };
})
