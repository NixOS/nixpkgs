rec {

  # Content-addressable Nix mirrors.
  hashedMirrors = [
    http://nix.cs.uu.nl/dist/tarballs
  ];

  # Mirrors for mirror://site/filename URIs, where "site" is
  # "sourceforge", "gnu", etc.
  
  # SourceForge.
  sourceforge = [
    http://prdownloads.sourceforge.net/
    http://heanet.dl.sourceforge.net/sourceforge/
    http://surfnet.dl.sourceforge.net/sourceforge/
    http://dfn.dl.sourceforge.net/sourceforge/
    http://mesh.dl.sourceforge.net/sourceforge/
    http://ovh.dl.sourceforge.net/sourceforge/
    http://osdn.dl.sourceforge.net/sourceforge/
    http://kent.dl.sourceforge.net/sourceforge/
  ];

  sf = sourceforge;

  # GNU.
  gnu = [
    ftp://ftp.nluug.nl/pub/gnu/
    http://mirrors.kernel.org/gnu/
    http://ftp.gnu.org/pub/gnu/
  ];

  # kernel.org's /pub (/pub/{linux,software}) tree.
  kernel = [
    http://www.all.kernel.org/pub/
    http://www.eu.kernel.org/pub/
    http://www.de.kernel.org/pub/
  ];

  # Mirrors of ftp://ftp.kde.org/pub/kde/.
  kde = [
    http://ftp.scarlet.be/pub/kde/
    http://ftp.gwdg.de/pub/x11/kde/
    ftp://ftp.heanet.ie/mirrors/ftp.kde.org/
    ftp://ftp.kde.org/pub/kde/
  ];

  # Gentoo files.
  gentoo = [
    http://www.ibiblio.org/pub/Linux/distributions/gentoo/
    http://distfiles.gentoo.org/
  ];

  savannah = [
    ftp://ftp.twaren.net/Unix/NonGNU/
    ftp://mirror.csclub.uwaterloo.ca/nongnu/
    ftp://mirror.publicns.net/pub/nongnu/
    ftp://savannah.c3sl.ufpr.br/
    http://download.savannah.gnu.org/
    http://ftp.cc.uoc.gr/mirrors/nongnu.org/
    http://ftp.twaren.net/Unix/NonGNU/
    http://mirror.csclub.uwaterloo.ca/nongnu/
    http://mirror.publicns.net/pub/nongnu/
    http://nongnu.askapache.com/
    http://nongnu.bigsearcher.com/
    http://savannah.c3sl.ufpr.br/
    http://www.centervenus.com/mirrors/nongnu/
    http://www.de-mirrors.de/nongnu/
    http://www.very-clever.com/download/nongnu/
    http://www.wikifusion.info/nongnu/
  ];

  # BitlBee mirrors, see http://www.bitlbee.org/main.php/mirrors.html .
  bitlbee = [
    http://get.bitlbee.org/
    http://get.bitlbee.be/
    http://get.us.bitlbee.org/
    http://ftp.snt.utwente.nl/pub/software/bitlbee/
    http://bitlbee.intergenia.de/
  ];

  # ImageMagick mirrors, see http://www.imagemagick.org/script/download.php .
  imagemagick = [
    ftp://gd.tuwien.ac.at/pub/graphics/ImageMagick/
    ftp://ftp.carnet.hr/pub/misc/imagemagick/
    ftp://ftp.fu-berlin.de/unix/X11/graphics/ImageMagick
    http://imagemagick.linux-mirror.org/download
    http://image_magick.veidrodis.com/image_magick/
    http://imagemagick.oss-mirror.org/download
    ftp://ftp.kddlabs.co.jp/graphics/ImageMagick/
    ftp://ftp.u-aizu.ac.jp/pub/graphics/image/ImageMagick/imagemagick.org
    ftp://zoffy.asahi-net.or.jp/pub/graphics/ImageMagick
    ftp://ftp.nluug.nl/pub/ImageMagick
    http://ftp.surfnet.nl/pub/ImageMagick/
    ftp://sunsite.icm.edu.pl/packages/ImageMagick/
    ftp://ftp.chg.ru/packages/ImageMagick
    http://ftp.chg.ru/packages/ImageMagick
    http://ftp.efair.ru/pub/software/graphics/ImageMagick/
    ftp://ftp.efair.ru/pub/software/graphics/ImageMagick/
    ftp://ftp.sunet.se/pub/multimedia/graphics/ImageMagick
    http://www.smudge-it.co.uk/pub/imagemagick/
    ftp://www.rx-host.net/pub/graphics/ImageMagick
    ftp://ftp.fifi.org/pub/ImageMagick/
    ftp://ftp.imagemagick.org/pub/ImageMagick
    ftp://ftp.imagemagick.net/pub/ImageMagick
    http://imagemagick.site2nd.org/imagemagick
  ];

  # CPAN mirrors.
  cpan = [
    http://ftp.gwdg.de/pub/languages/perl/CPAN/
    ftp://download.xs4all.nl/pub/mirror/CPAN/
    ftp://ftp.nl.uu.net/pub/CPAN/
    http://ftp.funet.fi/pub/CPAN/
  ];

  # Debian.
  debian = [
    ftp://ftp.de.debian.org/debian/pool/
    ftp://ftp.nl.debian.org/debian/pool/
    ftp://ftp.ru.debian.org/debian/pool/
    ftp://ftp.debian.org/debian/pool/
  ];

  # Gnome (see http://ftp.gnome.org/pub/GNOME/MIRRORS).
  gnome = [
    # This one redirects to some mirror closeby, so it should be all you need.
    http://download.gnome.org/
  ];

}
