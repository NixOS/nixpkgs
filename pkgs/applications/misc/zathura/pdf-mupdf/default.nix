{
  stdenv,
  lib,
  meson,
  ninja,
  fetchFromGitHub,
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
  appstream,
  appstream-glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2026.02.03";
  pname = "zathura-pdf-mupdf";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-pdf-mupdf";
    tag = finalAttrs.version;
    hash = "sha256-pNaawaExmBYDJbry/Ek/EpP2mojHp3MZw3cR6ku2jeg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream
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

  passthru.updateScript = gitUpdater { };

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
