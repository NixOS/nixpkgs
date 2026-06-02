{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorgproto,
  libxcb,
  autoreconfHook,
  json-glib,
  gtk-doc,
  which,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i3ipc-glib";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "i3ipc-glib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F9Tiwc/gB7BFWr/qerS4n/+k/nUvJsH7Bp2zb1fe3wU=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    which
    pkg-config
    gtk-doc
    gobject-introspection
  ];

  buildInputs = [
    libxcb
    json-glib
    xorgproto
  ];

  preAutoreconf = ''
    gtkdocize
  '';

  meta = {
    description = "C interface library to i3wm";
    homepage = "https://github.com/acrisci/i3ipc-glib";
    maintainers = with lib.maintainers; [ teto ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
