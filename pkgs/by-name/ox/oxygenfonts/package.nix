{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "oxygenfonts";
  version = "5.4.3";

  src = fetchzip {
    url = "https://invent.kde.org/unmaintained/oxygen-fonts/-/archive/v${finalAttrs.version}/oxygen-fonts-v${finalAttrs.version}.zip";
    hash = "sha256-N8fU5/iqgtFqaqdGuqbEVDsFCmVcHXLodo/T5NZMu8U=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Desktop/gui font for integrated use with the KDE desktop";
    longDescription = ''
      Oxygen Font is a font family originally aimed as a desktop/gui
      font for integrated use with the KDE desktop.

      The basic concept for Oxygen Font was to design a clear,
      legible, sans serif, that would be rendered with Freetype on
      Linux-based devices. In addition a bold weight, plus regular and
      bold italics, and a monospace version will be made.

      Oxygen is constructed closely with the gridfitting aspects of
      the Freetype font rendering engine. The oxygen fonts are also
      autohinted with Werner Lemberg's "ttfautohint" library to
      further the compatibility with the Freetype engine. The aim of
      this approach is to produce a family of freetype-specific
      desktop fonts whose appearance will stay uniform under different
      screen render settings, unlike more traditionally designed
      'screen fonts' that have tended to be designed for best
      legibility on the Windows GDI render engine.

      The main creator of Oxygen, Vernon Adams, suffered a heavy
      traffic accident three months after its last release, causing him severe brain
      injury. He finally passed away, sans oxygen, on August 25th 2016.
      See: http://sansoxygen.com/
    '';

    homepage = "https://github.com/vernnobile/oxygenFont";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ VarNepvius ];
    platforms = lib.platforms.all;
  };
})
