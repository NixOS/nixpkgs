{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libx11,
  xorgproto,
  cairo,
  lv2,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "GxMatchEQ.lv2";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "GxMatchEQ.lv2";
    rev = "V${finalAttrs.version}";
    hash = "sha256-4jg6DYkNRuNuQpOnsZfwJAZljBmBRzS6NcJKjv+r7Ss=";
  };

  patches = [
    # _LV2UI_Descriptor was mistakenly used instead of LV2UI_Descriptor in one
    # signature.
    (fetchpatch {
      name = "use-lv2ui_descriptor-name.patch";
      url = "https://github.com/brummer10/GxMatchEQ.lv2/commit/4ca70be32220729a5253c0bb46f5aded5ba3d00a.patch";
      hash = "sha256-EKlv6UptUpP+LOG7S30L21o0/upeDj6WB1PZ44XtNRU=";
    })
  ];

  # without the Xresource.h header, compilation on gcc versions > 13 fails with
  # gui/gx_matcheq_x11ui.c:360:27: error: implicit declaration of function 'XrmUniqueQuark' [-Wimplicit-function-declaration]
  postPatch = ''
    sed -e '1i #include <X11/Xresource.h>' -i gui/gx_matcheq_x11ui.c
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    xorgproto
    cairo
    lv2
  ];

  # error: format not a string literal and no format arguments [-Werror=format-security]
  hardeningDisable = [ "format" ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  meta = {
    homepage = "https://github.com/brummer10/GxMatchEQ.lv2";
    description = "Matching Equalizer to apply EQ curve from one source to another source";
    maintainers = with lib.maintainers; [ magnetophon ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
