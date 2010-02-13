{ fetchurl, stdenv, texLive, guile, libX11, libXext }:

let version = "1.0.7"; in
stdenv.mkDerivation {
  name = "texmacs-${version}";

  src = fetchurl {
    url = "ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-${version}-src.tar.gz";
    sha256 = "1jdynapwc4fnp4ff71whq7l2jv0v3zwq2v2w463ppxm9cbi3bm5v";
  };

  buildInputs = [ texLive guile libX11 libXext ];

  meta = {
    description = "GNU TeXmacs, a WYSIWYW editing platform with special features for scientists";

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

    homepage = http://texmacs.org/;

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
