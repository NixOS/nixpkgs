{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  gtk-doc,
  xkeyboard_config,
  libxml2,
  libxi,
  libx11,
  libice,
  xkbcomp,
  libxkbfile,
  docbook_xsl,
  glib,
  isocodes,
  gobject-introspection,
  withDoc ? (stdenv.buildPlatform == stdenv.hostPlatform),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxklavier";
  version = "5.4";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/archived-projects/libxklavier.git";
    tag = "libxklavier-${finalAttrs.version}";
    hash = "sha256-6uzfuVaQlnMMURIke+ZLqL0PhPEmCzx4bFR4+nItPfA=";
  };

  patches = [
    ./honor-XKB_CONFIG_ROOT.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/archived-projects/libxklavier/-/commit/1387c21a788ec1ea203c8392ea1460fc29d83f70.patch";
      sha256 = "sha256-fyWu7sVfDv/ozjhLSLCVsv+iNFawWgJqHUsQHHSkQn4=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDoc [ "devdoc" ];

  # TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = [
    libx11
    libxi
    xkeyboard_config
    libxml2
    libice
    glib
    libxkbfile
    isocodes
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
    docbook_xsl
    gobject-introspection
  ];

  strictDeps = true;

  preAutoreconf = ''
    export NOCONFIGURE=1
    gtkdocize
  '';

  configureFlags = [
    "--with-xkb-base=${xkeyboard_config}/etc/X11/xkb"
    "--with-xkb-bin-base=${xkbcomp}/bin"
    "--disable-xmodmap-support"
    "${if withDoc then "--enable-gtk-doc" else "--disable-gtk-doc"}"
  ];

  meta = {
    description = "Library providing high-level API for X Keyboard Extension known as XKB";
    homepage = "http://freedesktop.org/wiki/Software/LibXklavier";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
