{
  stdenv,
  lib,
  meson,
  ninja,
  fetchurl,
  cairo,
  girara,
  gtk-mac-integration,
  gumbo,
  jbig2dec,
  libjpeg,
  mupdf,
  openjpeg,
  pkg-config,
  zathura_core,
  tesseract,
  leptonica,
  mujs,
  desktop-file-utils,
  appstream-glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4.4";
  pname = "zathura-pdf-mupdf";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/zathura-pdf-mupdf-${finalAttrs.version}.tar.xz";
    hash = "sha256-ASViSQHKvjov5jMVpG59lmoyPAKP9TiQ3694Vq2x9Pw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream-glib
  ];

  buildInputs = [
    cairo
    girara
    gumbo
    jbig2dec
    libjpeg
    mupdf
    openjpeg
    zathura_core
    tesseract
    leptonica
    mujs
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration;

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  postPatch = ''
    sed -i -e '/^mupdfthird =/d' -e 's/, mupdfthird//g' meson.build
  '';

  passthru.updateScript = gitUpdater { url = "https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git"; };

  meta = {
    homepage = "https://pwmt.org/projects/zathura-pdf-mupdf/";
    description = "Zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
