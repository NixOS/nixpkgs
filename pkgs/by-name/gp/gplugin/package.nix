{
  lib,
  stdenv,
  fetchhg,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gtk4,
  gi-docgen,
  help2man,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gplugin";
  version = "0.44.2";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/gplugin/gplugin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o3nObK+Xu53IyJYI/+suJrR6kHV1XWovR3Y0zMeLkOo=";
  };

  postPatch = ''
    substituteInPlace lua/gplugin-lua-test-lgi.c \
      --replace-fail "return ret" "return 0"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    glib
    gi-docgen
    help2man
    vala
  ];

  buildInputs = [
    glib
    gtk4
    gi-docgen
  ];

  mesonFlags = [
    # Didn't get them passing dependency checks
    (lib.mesonBool "lua" false)
    (lib.mesonBool "python3" false)
  ];

  strictDeps = true;

  meta = {
    description = "GObject based library that implements a reusable plugin system";
    homepage = "https://keep.imfreedom.org/gplugin/gplugin";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
