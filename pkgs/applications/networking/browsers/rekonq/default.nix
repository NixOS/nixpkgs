{ stdenv, fetchurl, kdelibs, gettext, pkgconfig, shared_desktop_ontologies, qca2, qoauth }:

stdenv.mkDerivation rec {
  name = "rekonq-1.1";

  src = fetchurl {
    url = "mirror://sourceforge/rekonq/${name}.tar.bz2";
    sha256 = "1bs733mwyfb7bxnial8n49b82ip04sark2mxwlq7ixxsbgq7972l";
  };

  buildInputs = [ kdelibs qca2 qoauth ];

  nativeBuildInputs = [ gettext pkgconfig shared_desktop_ontologies ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}
