{
  lib,
  fetchFromGitHub,
  stdenv,
  meson,
  gettext,
  blueprint-compiler,
  python3,
  gtk4,
  cmake,
  pkg-config,
  desktop-file-utils,
  ninja,
  libadwaita,
  wrapGAppsHook4,
  gobject-introspection,
  gst_all_1,
  libsecret,
  glib-networking,
}:

let
  pythonEnv = python3.withPackages (
    pypkgs: with pypkgs; [
      pygobject3
      gst-python
      requests
      tidalapi
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "high-tide";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = pname;
    rev = "f5192ce";
    hash = "sha256-Sm2BrxXIu7wutBm/Oy8aCv+yamcJG3kt5za3uYESbMI=";
  };

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    pythonEnv
    gtk4
    libsecret
    glib-networking
  ];

  nativeBuildInputs = [
    meson
    cmake
    desktop-file-utils
    ninja
    gettext
    blueprint-compiler
    wrapGAppsHook4
    gobject-introspection
    pkg-config
    libadwaita
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # XDG_CACHE_HOME needs to be set, or high-tide will save images to its working dir.
      --prefix XDG_CACHE_HOME : "/tmp"
    )
  '';

  meta = with lib; {
    description = "Linux client for TIDAL streaming service ";
    homepage = "https://github.com/Nokse22/high-tide";
    license = licenses.gpl3;
    maintainers = with maintainers; [ totaltax ];
    platforms = platforms.linux;
  };
}
