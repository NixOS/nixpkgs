{stdenv, fetchurl, automake, gettext, freetype, libxml2, pango, pkgconfig
, wxGTK, gtk2, perl, zip}:

stdenv.mkDerivation {
  name = "xaralx-0.7r1785";

  src = fetchurl {
    url = http://downloads2.xara.com/opensource/XaraLX-0.7r1785.tar.bz2;
    sha256 = "05xbzq1i1vw2mdsv7zjqfpxfv3g1j0g5kks0gq6sh373xd6y8lyh";
  };

  nativeBuildInputs = [ automake pkgconfig gettext perl zip ];
  buildInputs = [ wxGTK gtk2 libxml2 freetype pango ];

  configureFlags = [ "--disable-svnversion" ];

  patches = map fetchurl (import ./debian-patches.nix);

  prePatch = "patchShebangs Scripts";

  meta.broken = true;
}
