{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wayland,
  cairo,
  pango,
  gtk,
  pkg-config,
  scdoc,
  libnotify,
  glib,
  wrapGAppsHook3,
  hicolor-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "swappy";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "jtheoof";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/XPvy98Il4i8cDl9vH6f0/AZmiSqseSXnen7HfMqCDo=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    scdoc
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    pango
    gtk
    libnotify
    wayland
    glib
    hicolor-icon-theme
  ];

  strictDeps = true;

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  meta = with lib; {
    description = "Wayland native snapshot editing tool, inspired by Snappy on macOS";
    homepage = "https://github.com/jtheoof/swappy";
    license = licenses.mit;
    mainProgram = "swappy";
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}
