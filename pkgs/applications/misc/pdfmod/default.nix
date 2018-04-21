{ stdenv, fetchurl, fetchpatch, pkgconfig, gnome-doc-utils, intltool, lib
, mono, gtk-sharp-2_0, gnome-sharp, hyena
, which, makeWrapper, glib, gnome3, poppler, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "pdfmod-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://gnome/sources/pdfmod/0.9/pdfmod-${version}.tar.bz2";
    sha256 = "eb7c987514a053106ddf03f26544766c751c801d87762909b36415d46bc425c9";
  };

  patches = [ (fetchpatch {
    url = "https://raw.githubusercontent.com/City-busz/Arch-Linux-Repository"
      + "/master/gnome/pdfmod/pdfmod/pdfmod-mono-2.10.patch";
    sha256 = "0fpz9ifr6476lqhd5rkb94dm68vlrwdq5w1aaxzgyjgdax9hxx81";
  }) ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnome-doc-utils intltool mono gtk-sharp-2_0 gnome-sharp
    hyena which makeWrapper wrapGAppsHook
  ];

  preConfigure = ''
    substituteInPlace lib/poppler-sharp/poppler-sharp/poppler-sharp.dll.config \
      --replace libpoppler-glib.so.4 libpoppler-glib.so
  '';

  postInstall = ''
    makeWrapper "${mono}/bin/mono" "$out/bin/pdfmod" \
      --add-flags "$out/lib/pdfmod/PdfMod.exe" \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --prefix MONO_GAC_PREFIX : ${gnome-sharp} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glib gnome-sharp gnome3.gconf gtk-sharp-2_0 gtk-sharp-2_0.gtk poppler ]}
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/PdfMod;
    description = "A simple application for modifying PDF documents";
    platforms = platforms.all;
    maintainers = with maintainers; [ obadz ];
  };
}
