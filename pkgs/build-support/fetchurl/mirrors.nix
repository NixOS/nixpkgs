rec {

  # Content-addressable Nix mirrors.
  hashedMirrors = [
    http://tarballs.nixos.org
  ];

  # Mirrors for mirror://site/filename URIs, where "site" is
  # "sourceforge", "gnu", etc.

  # SourceForge.
  sourceforge = [
    http://prdownloads.sourceforge.net/
    http://heanet.dl.sourceforge.net/sourceforge/
    http://surfnet.dl.sourceforge.net/sourceforge/
    http://dfn.dl.sourceforge.net/sourceforge/
    http://osdn.dl.sourceforge.net/sourceforge/
    http://kent.dl.sourceforge.net/sourceforge/
  ];

  # SourceForge.jp.
  sourceforgejp = [
    http://osdn.dl.sourceforge.jp/
    http://jaist.dl.sourceforge.jp/
  ];

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
    ftp://ftp.funet.fi/pub/mirrors/ftp.gnu.org/gnu/

    # This one is the master repository, and thus it's always up-to-date.
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
    https://gnupg.org/ftp/gcrypt/
    http://www.ring.gr.jp/pub/net/
    http://gd.tuwien.ac.at/privacy/
    http://mirrors.dotsrc.org/
    http://ftp.heanet.ie/mirrors/ftp.gnupg.org/
    http://www.mirrorservice.org/sites/ftp.gnupg.org/
  ];

  # kernel.org's /pub (/pub/{linux,software}) tree.
  kernel = [
    http://cdn.kernel.org/pub/
    http://www.all.kernel.org/pub/
    http://ramses.wh2.tu-dresden.de/pub/mirrors/kernel.org/
    http://linux-kernel.uio.no/pub/
    http://kernel.osuosl.org/pub/
    ftp://ftp.funet.fi/pub/mirrors/ftp.kernel.org/pub/
  ];

  # Mirrors of ftp://ftp.kde.org/pub/kde/.
  kde = [
    "http://download.kde.org/download.php?url="
    http://ftp.gwdg.de/pub/x11/kde/
    ftp://ftp.heanet.ie/mirrors/ftp.kde.org/
    ftp://ftp.kde.org/pub/kde/
    ftp://ftp.funet.fi/pub/mirrors/ftp.kde.org/pub/kde/
  ];

  # Gentoo files.
  gentoo = [
    http://ftp.snt.utwente.nl/pub/os/linux/gentoo/
    http://distfiles.gentoo.org/
    ftp://mirrors.kernel.org/gentoo/
  ];

  savannah = [
    ftp://mirror.csclub.uwaterloo.ca/nongnu/
    ftp://mirror.publicns.net/pub/nongnu/
    ftp://savannah.c3sl.ufpr.br/
    http://download.savannah.gnu.org/releases/
    http://ftp.cc.uoc.gr/mirrors/nongnu.org/
    http://ftp.twaren.net/Unix/NonGNU/
    http://mirror.csclub.uwaterloo.ca/nongnu/
    http://nongnu.askapache.com/
    http://savannah.c3sl.ufpr.br/
    http://www.centervenus.com/mirrors/nongnu/
  ];

  samba = [
    http://samba.org/ftp/
    http://ftp.riken.jp/net/samba
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
    http://www.imagemagick.org/download/
    ftp://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/ # also contains older versions removed from most mirrors
    http://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/
    ftp://ftp.imagemagick.org/pub/ImageMagick/
    http://ftp.fifi.org/ImageMagick/
    ftp://ftp.fifi.org/ImageMagick/
    http://imagemagick.mirrorcatalogs.com/
    ftp://imagemagick.mirrorcatalogs.com/imagemagick
  ];

  # CPAN mirrors.
  cpan = [
    http://ftp.gwdg.de/pub/languages/perl/CPAN/
    ftp://download.xs4all.nl/pub/mirror/CPAN/
    ftp://ftp.nl.uu.net/pub/CPAN/
    http://ftp.funet.fi/pub/CPAN/
    http://cpan.perl.org/
    http://backpan.perl.org/  # for old releases
  ];

  # Debian.
  debian = [
    http://httpredir.debian.org/debian/
    ftp://ftp.au.debian.org/debian/
    ftp://ftp.de.debian.org/debian/
    ftp://ftp.es.debian.org/debian/
    ftp://ftp.fr.debian.org/debian/
    ftp://ftp.it.debian.org/debian/
    ftp://ftp.nl.debian.org/debian/
    ftp://ftp.ru.debian.org/debian/
    ftp://ftp.debian.org/debian/
    http://ftp.debian.org/debian/
    http://archive.debian.org/debian-archive/debian/
    ftp://ftp.funet.fi/pub/mirrors/ftp.debian.org/debian/
  ];

  # Ubuntu.
  ubuntu = [
    http://nl.archive.ubuntu.com/ubuntu/
    http://de.archive.ubuntu.com/ubuntu/
    http://archive.ubuntu.com/ubuntu/
    http://old-releases.ubuntu.com/ubuntu/
  ];

  # Fedora (please only add full mirrors that carry old Fedora distributions as well).
  # See: https://mirrors.fedoraproject.org/publiclist (but not all carry old content).
  fedora = [
    http://archives.fedoraproject.org/pub/fedora/
    http://fedora.osuosl.org/
    http://ftp.nluug.nl/pub/os/Linux/distr/fedora/
    http://ftp.funet.fi/pub/mirrors/ftp.redhat.com/pub/fedora/
    http://fedora.bhs.mirrors.ovh.net/
    http://mirror.csclub.uwaterloo.ca/fedora/
    http://ftp.linux.cz/pub/linux/fedora/
    http://ftp.heanet.ie/pub/fedora/
    http://mirror.1000mbps.com/fedora/
    http://archives.fedoraproject.org/pub/archive/fedora/
  ];

  # Old SUSE distributions.  Unfortunately there is no master site,
  # since SUSE actually delete their old distributions (see
  # ftp://ftp.suse.com/pub/suse/discontinued/deleted-20070817/README.txt).
  oldsuse = [
    ftp://ftp.gmd.de/ftp.suse.com-discontinued/
  ];

  # openSUSE.
  opensuse = [
    http://opensuse.hro.nl/opensuse/distribution/
    http://ftp.funet.fi/pub/linux/mirrors/opensuse/distribution/
    http://ftp.belnet.be/mirror/ftp.opensuse.org/distribution/
    http://ftp.uni-kassel.de/opensuse/distribution/
    http://ftp.opensuse.org/pub/opensuse/distribution/
    http://ftp5.gwdg.de/pub/opensuse/discontinued/distribution/
    http://ftp.hosteurope.de/mirror/ftp.opensuse.org/discontinued/
    http://opensuse.mirror.server4you.net/distribution/
    http://ftp.nsysu.edu.tw/Linux/OpenSuSE/distribution/
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

  xfce = [
    http://archive.xfce.org/
    http://mirror.netcologne.de/xfce/
    http://archive.se.xfce.org/xfce/
    http://archive.be.xfce.org/xfce/
    http://mirror.perldude.de/archive.xfce.org/
    http://archive.be2.xfce.org/
    http://ftp.udc.es/xfce/
    http://archive.al-us.xfce.org/
    http://mirror.yongbok.net/X11/xfce-mirror/
    http://mirrors.tummy.com/pub/archive.xfce.org/
    http://xfce.mirror.uber.com.au/
  ];

  # X.org.
  xorg = [
    http://xorg.freedesktop.org/releases/
    http://ftp.gwdg.de/pub/x11/x.org/pub/
    http://ftp.x.org/pub/ # often incomplete (e.g. files missing from X.org 7.4)
  ];

  # Apache mirrors (see http://www.apache.org/mirrors/).
  apache = [
    http://www.eu.apache.org/dist/
    ftp://ftp.inria.fr/pub/Apache/
    http://apache.cict.fr/
    ftp://ftp.fu-berlin.de/unix/www/apache/
    ftp://crysys.hit.bme.hu/pub/apache/dist/
    http://mirror.cc.columbia.edu/pub/software/apache/
    http://www.apache.org/dist/
    http://archive.apache.org/dist/ # fallback for old releases
    ftp://ftp.funet.fi/pub/mirrors/apache.org/
    http://apache.cs.uu.nl/dist/
    http://apache.cs.utah.edu/
  ];

  postgresql = [
    http://ftp.postgresql.org/pub/
    ftp://ftp.postgresql.org/pub/
    ftp://ftp-archives.postgresql.org/pub/
  ];

  metalab = [
    ftp://mirrors.kernel.org/metalab/
    ftp://ftp.gwdg.de/pub/linux/metalab/
    ftp://ftp.xemacs.org/sites/metalab.unc.edu/
  ];

  # Bioconductor mirrors (from http://bioconductor.org/about/mirrors)
  # The commented-out ones don't seem to allow direct package downloads;
  # they serve error messages that result in hash mismatches instead.
  bioc = [
    # http://bioc.ism.ac.jp/
    # http://bioc.openanalytics.eu/
    # http://bioconductor.fmrp.usp.br/
    # http://mirror.aarnet.edu.au/pub/bioconductor/
    # http://watson.nci.nih.gov/bioc_mirror/
    http://bioconductor.jp/packages/
    http://bioconductor.statistik.tu-dortmund.de/packages/
    http://mirrors.ebi.ac.uk/bioconductor/packages/
    http://mirrors.ustc.edu.cn/bioc/
  ];

  # Hackage mirrors
  hackage = [
    http://hackage.haskell.org/package/
    http://hdiff.luite.com/packages/archive/package/
  ];

  # Roy marples mirrors
  roy = [
    http://roy.marples.name/downloads/
    http://roy.aydogan.net/
    http://cflags.cc/roy/
  ];

  # Sage mirrors (http://www.sagemath.org/mirrors.html)
  sagemath = [
    http://boxen.math.washington.edu/home/sagemath/sage-mirror/src/
    http://echidna.maths.usyd.edu.au/sage/src/
    http://ftp.iitm.ac.in/sage/src/
    http://ftp.kaist.ac.kr/sage/src/
    http://ftp.riken.jp/sagemath/src/
    http://ftp.tsukuba.wide.ad.jp/software/sage/src/
    http://jambu.spms.ntu.edu.sg/sage/src/
    http://linorg.usp.br/sage/src/
    http://mirror.aarnet.edu.au/pub/sage/src/
    http://mirror.clibre.uqam.ca/sage/src/
    http://mirror.hust.edu.cn/sagemath/src/
    http://mirror.switch.ch/mirror/sagemath/src/
    http://mirror.yandex.ru/mirrors/sage.math.washington.edu/src/
    http://mirrors.fe.up.pt/pub/sage/src/
    http://mirrors.hustunique.com/sagemath/src/
    http://mirrors.ustc.edu.cn/sagemath/src/
    http://mirrors.xmission.com/sage/src/
    http://sage.asis.io/src/
    http://sage.mirror.garr.it/mirrors/sage/src/
    http://sage.yasar.edu.tr/src/
    http://sagemath.c3sl.ufpr.br/src/
    http://sagemath.polytechnic.edu.na/src/
    http://sunsite.rediris.es/mirror/sagemath/src/
    http://www-ftp.lip6.fr/pub/math/sagemath/src/
    http://www.mirrorservice.org/sites/www.sagemath.org/src/

    # Old versions
    http://www.cecm.sfu.ca/sage/src/
    http://sagemath.org/src-old/
  ];

  # MySQL mirrors
  mysql = [
    http://mysql.mirrors.pair.com/Downloads/
    http://cdn.mysql.com/Downloads/
  ];

  # OpenBSD mirrors
  openbsd = [
    http://ftp.openbsd.org/pub/OpenBSD/
    ftp://ftp.nluug.nl/pub/OpenBSD/
    ftp://ftp-stud.fht-esslingen.de/pub/OpenBSD/
    ftp://ftp.halifax.rwth-aachen.de/pub/OpenBSD/
    ftp://mirror.switch.ch/pub/OpenBSD/
  ];

  # Steam Runtime mirrors
  steamrt = [
    http://repo.steampowered.com/steamrt/
    https://abbradar.net/steamrt/
  ];

  # Python PyPI mirrors
  pypi = [
    https://pypi.io/packages/source/
  ];
}
