{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "oxygenfonts";
  version = "20160824";

  src = fetchFromGitHub {
    owner = "vernnobile";
    repo = "oxygenFont";
    rev = "62db0ebe3488c936406685485071a54e3d18473b";
    hash = "sha256-0LKq8nChkDAb6U1sOUyga/DvzpDmIjoRn+2PB9rok4w=";
  };

  # Remove stuff that we don't need or would cause conflicts
  buildPhase = ''
    rm -r Oxygen-GoogleWebFont
    rm -r OxygenSans-version-0.2
    find -type d -name src -delete
  '';

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

    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ VarNepvius ];
    platforms = lib.platforms.all;
  };
}
