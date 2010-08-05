rec {

  # Content-addressable Nix mirrors.
  hashedMirrors = [
    http://nixos.org/tarballs
  ];

  # Mirrors for mirror://site/filename URIs, where "site" is
  # "sourceforge", "gnu", etc.
  
  # SourceForge.
  sourceforge = [
    http://heanet.dl.sourceforge.net/sourceforge/
    http://surfnet.dl.sourceforge.net/sourceforge/
    http://dfn.dl.sourceforge.net/sourceforge/
    http://mesh.dl.sourceforge.net/sourceforge/
    http://ovh.dl.sourceforge.net/sourceforge/
    http://osdn.dl.sourceforge.net/sourceforge/
    http://kent.dl.sourceforge.net/sourceforge/
    http://prdownloads.sourceforge.net/
  ];

  sf = sourceforge;

  # GNU (http://www.gnu.org/prep/ftp.html).
  gnu = [
    # This one redirects to a (supposedly) nearby and (supposedly) up-to-date
    # mirror.
    http://ftpmirror.gnu.org/

    http://ftp.nluug.nl/pub/gnu/
    http://mirrors.kernel.org/gnu/
    ftp://mirror.cict.fr/gnu/
    ftp://ftp.cs.tu-berlin.de/pub/gnu/
    ftp://ftp.chg.ru/pub/gnu/

    http://ftp.gnu.org/pub/gnu/
  ];

  # GCC.
  gcc = [
    ftp://ftp.nluug.nl/mirror/languages/gcc/
    ftp://ftp.fu-berlin.de/unix/languages/gcc/
    ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/
    ftp://gcc.gnu.org/pub/gcc/
  ];

  # GnuPG.
  gnupg = [
    ftp://gd.tuwien.ac.at/privacy/gnupg/
    ftp://gnupg.x-zone.org/pub/gnupg/
    ftp://ftp.gnupg.cz/pub/gcrypt/
    ftp://sunsite.dk/pub/security/gcrypt/
    http://gnupg.wildyou.net/
    http://ftp.gnupg.zone-h.org/
    ftp://ftp.jyu.fi/pub/crypt/gcrypt/
    ftp://trumpetti.atm.tut.fi/gcrypt/
    ftp://mirror.cict.fr/gnupg/
    ftp://ftp.strasbourg.linuxfr.org/pub/gnupg/
    ftp://ftp.cert.dfn.de/pub/tools/crypt/gcrypt/
    ftp://ftp.franken.de/pub/crypt/mirror/ftp.gnupg.org/gcrypt/
    ftp://ftp.freenet.de/pub/ftp.gnupg.org/gcrypt/
    ftp://hal.csd.auth.gr/mirrors/gnupg/
    ftp://igloo.linux.gr/pub/crypto/gnupg/
    ftp://ftp.uoi.gr/mirror/gcrypt/
    ftp://ftp.crysys.hu/pub/gnupg/
    ftp://ftp.kfki.hu/pub/packages/security/gnupg/
    ftp://ftp.hi.is/pub/mirrors/gnupg/
    ftp://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/
    ftp://ftp3.linux.it/pub/mirrors/gnupg/
    ftp://ftp.linux.it/pub/mirrors/gnupg/
    ftp://ftp.bit.nl/mirror/gnupg/
    ftp://ftp.demon.nl/pub/mirrors/gnupg/
    ftp://ftp.surfnet.nl/pub/security/gnupg/
    ftp://sunsite.icm.edu.pl/pub/security/gnupg/
    ftp://ftp.iasi.roedu.net/pub/mirrors/ftp.gnupg.org/
    http://ftp.gnupg.tsuren.net/
    http://www.mirror386.com/gnupg/
    ftp://ftp.sunet.se/pub/security/gnupg/
    ftp://mirror.switch.ch/mirror/gnupg/
    ftp://ftp.mirrorservice.org/sites/ftp.gnupg.org/gcrypt

    http://gnupg.unixmexico.org/ftp/
    ftp://ftp.gnupg.ca/
    http://gulus.usherbrooke.ca/pub/appl/GnuPG/
    http://mirrors.rootmode.com/ftp.gnupg.org/

    ftp://ftp.planetmirror.com/pub/gnupg/

    ftp://pgp.iijlab.net/pub/pgp/gnupg/
    ftp://ftp.ring.gr.jp/pub/net/gnupg/
    ftp://gnupg.cdpa.nsysu.edu.tw/gnupg/
  ];

  # kernel.org's /pub (/pub/{linux,software}) tree.
  kernel = [
    http://www.all.kernel.org/pub/
    http://www.eu.kernel.org/pub/
    http://www.de.kernel.org/pub/
  ];

  # Mirrors of ftp://ftp.kde.org/pub/kde/.
  kde = [
    http://ftp.gwdg.de/pub/x11/kde/
    ftp://ftp.heanet.ie/mirrors/ftp.kde.org/
    ftp://ftp.kde.org/pub/kde/
  ];

  # Gentoo files.
  gentoo = [
    http://ftp.snt.utwente.nl/pub/os/linux/gentoo/
    http://distfiles.gentoo.org/
    ftp://mirrors.kernel.org/gentoo/
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
    http://nongnu.askapache.com/
    http://savannah.c3sl.ufpr.br/
    http://www.centervenus.com/mirrors/nongnu/
  ];

  # BitlBee mirrors, see http://www.bitlbee.org/main.php/mirrors.html .
  bitlbee = [
    http://get.bitlbee.org/
    http://get.bitlbee.be/
    http://get.us.bitlbee.org/
    http://ftp.snt.utwente.nl/pub/software/bitlbee/
    http://bitlbee.intergenia.de/
  ];

  # ImageMagick mirrors, see http://www.imagemagick.org/script/download.php.
  imagemagick = [
    http://ftp.nluug.nl/pub/ImageMagick/
    ftp://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/
    ftp://ftp.imagemagick.org/pub/ImageMagick/
    ftp://ftp.imagemagick.net/pub/ImageMagick/
  ];

  # CPAN mirrors.
  cpan = [
    http://ftp.gwdg.de/pub/languages/perl/CPAN/
    ftp://download.xs4all.nl/pub/mirror/CPAN/
    ftp://ftp.nl.uu.net/pub/CPAN/
    http://ftp.funet.fi/pub/CPAN/
    http://cpan.perl.org/
  ];

  # Debian.
  debian = [
    ftp://ftp.de.debian.org/debian/
    ftp://ftp.es.debian.org/debian/
    ftp://ftp.fr.debian.org/debian/
    ftp://ftp.it.debian.org/debian/
    ftp://ftp.nl.debian.org/debian/
    ftp://ftp.ru.debian.org/debian/
    ftp://ftp.debian.org/debian/
    http://archive.debian.org/debian-archive/debian/
  ];

  # Ubuntu.
  ubuntu = [
    http://nl.archive.ubuntu.com/ubuntu/
    http://de.archive.ubuntu.com/ubuntu/
    http://archive.ubuntu.com/ubuntu/
    http://old-releases.ubuntu.com/ubuntu/
  ];

  # Fedora (please only add full mirrors that carry old Fedora distributions as well).
  fedora = [
    http://ftp.nluug.nl/pub/os/Linux/distr/fedora/
    http://ftp.funet.fi/pub/mirrors/ftp.redhat.com/pub/fedora/
    http://download.fedora.redhat.com/pub/fedora/
    http://archives.fedoraproject.org/pub/archive/fedora/
  ];

  # Old SUSE distributions.  Unfortunately there is no master site,
  # since SUSE actually delete their old distributions (see
  # ftp://ftp.suse.com/pub/suse/discontinued/deleted-20070817/README.txt).
  oldsuse = [
    http://ftp.hosteurope.de/pub/linux/suse/discontinued/i386/
    ftp://ftp.gmd.de/ftp.suse.com-discontinued/
  ];

  # openSUSE.
  opensuse = [
    http://opensuse.hro.nl/opensuse/distribution/
    http://ftp.funet.fi/pub/linux/mirrors/opensuse/distribution/
    http://ftp.opensuse.org/pub/opensuse/distribution/
    http://ftp.hosteurope.de/mirror/ftp.opensuse.org/discontinued/
  ];

  # Gnome (see http://ftp.gnome.org/pub/GNOME/MIRRORS).
  gnome = [
    # This one redirects to some mirror closeby, so it should be all you need.
    http://download.gnome.org/

    http://ftp.unina.it/pub/linux/GNOME/
    http://fr2.rpmfind.net/linux/gnome.org/
    ftp://ftp.dit.upm.es/pub/GNOME/
    ftp://ftp.no.gnome.org/pub/GNOME/
    http://ftp.acc.umu.se/pub/GNOME/
    http://ftp.belnet.be/mirror/ftp.gnome.org/
    http://ftp.df.lth.se/pub/gnome/
    http://linorg.usp.br/gnome/
    http://mirror.aarnet.edu.au/pub/GNOME/
    ftp://ftp.cse.buffalo.edu/pub/Gnome/
    ftp://ftp.nara.wide.ad.jp/pub/X11/GNOME/
  ];

  # X.org.
  xorg = [
    http://xorg.freedesktop.org/releases/
    http://ftp.gwdg.de/pub/x11/x.org/pub/
    http://ftp.x.org/pub/ # often incomplete (e.g. files missing from X.org 7.4)
  ];

  # Apache mirrors (see http://www.apache.org/mirrors/).
  apache = [
    http://apache.cs.uu.nl/dist/
    http://www.eu.apache.org/dist/
    ftp://ftp.inria.fr/pub/Apache/
    http://apache.cict.fr/
    ftp://ftp.fu-berlin.de/unix/www/apache/
    ftp://crysys.hit.bme.hu/pub/apache/dist/
    http://mirror.cc.columbia.edu/pub/software/apache/
    http://www.apache.org/dist/
    http://archive.apache.org/dist/ # fallback for old releases
  ];

  postgresql = [
    http://ftp2.nl.postgresql.org/
    ftp://ftp.nl.postgresql.org/pub/mirror/postgresql/
    ftp://ftp.postgresql.org/pub/
    ftp://ftp-archives.postgresql.org/pub/
  ];

}
