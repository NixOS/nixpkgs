{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  python3,
  python3Packages,
  libadwaita,
  gtk4,
  glib,
  glib-networking,
  gst_all_1,
  libsecret,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  gettext,
  desktop-file-utils,
  appstream,
  gobject-introspection,
  wrapGAppsHook4,
  xdg-user-dirs,
  cmake,
}:
let
  mpris-server = python3.pkgs.buildPythonPackage {
    pname = "mpris_server";
    version = "0.9.1";
    pyproject = true;
    src = fetchurl {
      url = "https://github.com/Jeffser/mpris_server/releases/download/v0.9.1/mpris_server-0.10.0.tar.gz";
      hash = "sha256-0+nYgTzLLlIWNcW/iAaQtbsoMDF44BqZrq3+6ZGTjnY=";
    };
    build-system = with python3.pkgs; [ hatchling ];
    propagatedBuildInputs = with python3.pkgs; [
      pydbus
      strenum
      unidecode
      emoji
    ];
    doCheck = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nocturne";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Nocturne";
    tag = finalAttrs.version;
    hash = "sha256-CfrPmpkjcmKMB66kdFL4HqVukaIWAkIzOkwtBqZ65k4=";
  };
  __structuredAttrs = true;
  dontUseCmakeConfigure = true;
  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream
    blueprint-compiler
    gobject-introspection
    wrapGAppsHook4
    glib
    cmake
    gtk4
    python3
  ];
  buildInputs = [
    libadwaita
    gtk4
    glib
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    libsecret
  ];
  pythonDependencies = [
    python3Packages.pygobject3
    python3Packages.tinytag
    python3Packages.requests
    python3Packages.pillow
    python3Packages.syncedlyrics
    python3Packages.colorthief
    mpris-server
  ];
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath finalAttrs.pythonDependencies}
    )
  '';

  patches = [ ./disable-navidrome-setup.patch ];

  meta = {
    description = "Adwaita music player for OpenSubsonic servers like Navidrome";
    homepage = "https://github.com/Jeffser/Nocturne";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nyxar77
      pbsds
    ];
    mainProgram = "nocturne";
    platforms = lib.platforms.linux;
  };
})
