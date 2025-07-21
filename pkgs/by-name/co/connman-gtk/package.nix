{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  python3,
  gtk3,
  connman,
  openconnect,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "connman-gtk";
  version = "1.1.1-unstable-2018-06-26";

  src = fetchFromGitHub {
    owner = "jgke";
    repo = "connman-gtk";
    rev = "b72c6ab3bb19c07325c8e659902b046daa23c506";
    hash = "sha256-6lX6FYERDgLj9G6nwnP35kF5x8dpRJqfJB/quZFtFzM=";
  };

  postPatch = ''
    patchShebangs --build data/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    openconnect
    connman
  ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/nickm/connman-gtk/-/raw/ef01b52fa02c5cca199b2e47c0cf360691266fd8/debian/patches/incompatible-pointer-type";
      hash = "sha256-T+N9FfDyROBA4/HLK+l/fpnju2imDU4y6nGSbF+JDiA=";
    })
  ];

  env.MESON_INSTALL_PREFIX = placeholder "out";

  meta = with lib; {
    description = "GTK GUI for Connman";
    mainProgram = "connman-gtk";
    homepage = "https://github.com/jgke/connman-gtk";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
