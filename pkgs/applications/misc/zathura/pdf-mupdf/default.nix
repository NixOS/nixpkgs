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
  gitUpdater,
}:

stdenv.mkDerivation rec {
  version = "0.4.2";
  pname = "zathura-pdf-mupdf";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    hash = "sha256-fFC+z9mJX9ccExsV336Ut+zJJa8UdfUz/qVp9YgcnhM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
  ] ++ lib.optional stdenv.isDarwin gtk-mac-integration;

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  postPatch = ''
    sed -i -e '/^mupdfthird =/d' -e 's/, mupdfthird//g' meson.build
  '';

  passthru.updateScript = gitUpdater { url = "https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git"; };

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-pdf-mupdf/";
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
