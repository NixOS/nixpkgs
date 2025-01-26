{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  gobject-introspection,
  glib,
  zimlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzim-glib";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "birros";
    repo = "libzim-glib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C1f/ULTJIHvt/LCSRw3dsGAWUkb1i4xaCmW1+QBZd2c=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    zimlib
  ];

  # requires downloading test sample of a specific zimlib version
  doCheck = false;

  meta = {
    description = "Partial GObject/C bindings for libzim";
    homepage = "https://github.com/birros/libzim-glib";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
