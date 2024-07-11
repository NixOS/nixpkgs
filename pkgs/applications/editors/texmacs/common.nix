{ lib, fetchurl, tex, extraFonts, chineseFonts, japaneseFonts, koreanFonts }:
rec {
  extraFontsSrc = fetchurl {
    url = "ftp://ftp.texmacs.org/pub/TeXmacs/fonts/TeXmacs-extra-fonts-1.0-noarch.tar.gz";
    sha256 = "0hylgjmd95y9yahbblmawkkw0i71vb145xxv2xqrmff81301n6k7";
  };

  fullFontsSrc = fetchurl {
    url = "ftp://ftp.texmacs.org/pub/TeXmacs/fonts/TeXmacs-windows-fonts-1.0-noarch.tar.gz";
    sha256 = "1yxzjpqpm7kvx0ly5jmfpzlfhsh41b0ibn1v84qv6xy73r2vis2f";
  };

  chineseFontsSrc = fetchurl {
    url = "ftp://ftp.texmacs.org/pub/TeXmacs/fonts/TeXmacs-chinese-fonts.tar.gz";
    sha256 = "0yprqjsx5mfsaxr525mcm3xqwcadzxp14njm38ir1325baada2fp";
  };

  japaneseFontsSrc = fetchurl {
    url = "ftp://ftp.texmacs.org/pub/TeXmacs/fonts/TeXmacs-japanese-fonts.tar.gz";
    sha256 = "1dn6zvsa7gk59d61xicwpbapab3rm6kz48rp5w1bhmihxixw21jn";
  };

  koreanFontsSrc = fetchurl {
    url = "ftp://ftp.texmacs.org/pub/TeXmacs/fonts/TeXmacs-korean-fonts.tar.gz";
    sha256 = "07axg57mqm3jbnm4lawx0h3r2h56xv9acwzjppryfklw4c27f5hh";
  };

  postPatch = (if tex == null then ''
    gunzip < ${fullFontsSrc} | (cd TeXmacs && tar xvf -)
   '' else lib.optionalString extraFonts ''
    gunzip < ${extraFontsSrc} | (cd TeXmacs && tar xvf -)
   '') +
   (lib.optionalString chineseFonts ''
    gunzip < ${chineseFontsSrc} | (cd TeXmacs && tar xvf -)
   '') +
   (lib.optionalString japaneseFonts ''
    gunzip < ${japaneseFontsSrc} | (cd TeXmacs && tar xvf -)
   '') +
   (lib.optionalString koreanFonts ''
    gunzip < ${koreanFontsSrc} | (cd TeXmacs && tar xvf -)
   '');


  meta = {
    description = "WYSIWYW editing platform with special features for scientists";
    longDescription =
    '' GNU TeXmacs is a free wysiwyw (what you see is what you want)
    editing platform with special features for scientists.  The software
    aims to provide a unified and user friendly framework for editing
    structured documents with different types of content (text,
    graphics, mathematics, interactive content, etc.).  The rendering
    engine uses high-quality typesetting algorithms so as to produce
    professionally looking documents, which can either be printed out or
    presented from a laptop.

    The software includes a text editor with support for mathematical
    formulas, a small technical picture editor and a tool for making
    presentations from a laptop.  Moreover, TeXmacs can be used as an
    interface for many external systems for computer algebra, numerical
    analysis, statistics, etc.  New presentation styles can be written
    by the user and new features can be added to the editor using the
    Scheme extension language.  A native spreadsheet and tools for
    collaborative authoring are planned for later.
  '';
    homepage = "http://texmacs.org/";
    license = lib.licenses.gpl2Plus;
  };
}
