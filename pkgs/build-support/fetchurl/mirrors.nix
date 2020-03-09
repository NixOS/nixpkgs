{

  # Content-addressable Nix mirrors.
  hashedMirrors = [
    http://tarballs.nixos.org
  ];

  # Mirrors for mirror://site/filename URIs, where "site" is
  # "sourceforge", "gnu", etc.

  luarocks = [
    https://luarocks.org
    https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/
    http://luafr.org/moonrocks
    http://luarocks.logiceditor.com/rocks
  ];

  # SourceForge.
  sourceforge = [
    https://downloads.sourceforge.net/
    https://prdownloads.sourceforge.net/
    https://heanet.dl.sourceforge.net/sourceforge/
    https://surfnet.dl.sourceforge.net/sourceforge/
    https://dfn.dl.sourceforge.net/sourceforge/
    https://osdn.dl.sourceforge.net/sourceforge/
    https://kent.dl.sourceforge.net/sourceforge/
  ];

  # OSDN (formerly SourceForge.jp).
  osdn = [
    https://osdn.dl.osdn.jp/
    https://osdn.mirror.constant.com/
    https://mirrors.gigenet.com/OSDN/
    https://osdn.dl.sourceforge.jp/
    https://jaist.dl.sourceforge.jp/
  ];

  # GNU (https://www.gnu.org/prep/ftp.html).
  gnu = [
    # This one redirects to a (supposedly) nearby and (supposedly) up-to-date
    # mirror.
    https://ftpmirror.gnu.org/

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
    https://bigsearcher.com/mirrors/gcc/
    http://mirror.koddos.net/gcc/
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
    http://mirrors.dotsrc.org/gcrypt/
    http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/
    http://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/
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

  # Mirrors from https://download.kde.org/extra/download-mirrors.html
  kde = [
    "https://download.kde.org/download.php?url="
    https://ftp.gwdg.de/pub/linux/kde/
    https://mirrors.ocf.berkeley.edu/kde/
    http://mirrors.mit.edu/kde/
    https://mirrors.ustc.edu.cn/kde/
    http://ftp.funet.fi/pub/mirrors/ftp.kde.org/pub/kde/
    ftp://ftp.kde.org/pub/kde/
  ];

  # Gentoo files.
  gentoo = [
    http://ftp.snt.utwente.nl/pub/os/linux/gentoo/
    http://distfiles.gentoo.org/
    ftp://mirrors.kernel.org/gentoo/
  ];

  savannah = [
    # Mirrors from https://download-mirror.savannah.gnu.org/releases/00_MIRRORS.html
    http://mirror.easyname.at/nongnu/
    http://mirror2.klaus-uwe.me/nongnu/
    http://savannah.c3sl.ufpr.br/
    http://mirror.csclub.uwaterloo.ca/nongnu/
    http://mirror.cedia.org.ec/nongnu/
    http://ftp.igh.cnrs.fr/pub/nongnu/
    http://mirror6.layerjet.com/nongnu
    http://mirror.netcologne.de/savannah/
    http://ftp.cc.uoc.gr/mirrors/nongnu.org/
    http://nongnu.uib.no/
    http://mirrors.fe.up.pt/pub/nongnu/
    http://mirror.lihnidos.org/GNU/savannah/
    http://savannah.mirror.si/
    http://ftp.acc.umu.se/mirror/gnu.org/savannah/
    http://ftp.twaren.net/Unix/NonGNU/
    http://ftp.yzu.edu.tw/pub/nongnu/
    http://mirror.rackdc.com/savannah/
    http://savannah-nongnu-org.ip-connect.vn.ua/
    http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/
    http://savannah.spinellicreations.com/
    http://gnu.mirrors.pair.com/savannah/savannah/
    ftp://mirror.easyname.at/nongnu/
    ftp://mirror2.klaus-uwe.me/nongnu/
    ftp://savannah.c3sl.ufpr.br/savannah-nongnu/
    ftp://mirror.csclub.uwaterloo.ca/nongnu/
    ftp://mirror.cedia.org.ec/nongnu
    ftp://ftp.igh.cnrs.fr/pub/nongnu/
    ftp://mirror6.layerjet.com/nongnu/
    ftp://mirror.netcologne.de/savannah/
    ftp://nongnu.uib.no/pub/nongnu/
    ftp://mirrors.fe.up.pt/pub/nongnu/
    ftp://savannah.mirror.si/savannah/
    ftp://ftp.twaren.net/Unix/NonGNU/
    ftp://ftp.yzu.edu.tw/pub/nongnu/
    ftp://savannah-nongnu-org.ip-connect.vn.ua/mirror/savannah.nongnu.org/
    ftp://ftp.mirrorservice.org/sites/download.savannah.gnu.org/releases/
    ftp://spinellicreations.com/gnu_dot_org_savannah_mirror/
  ];

  samba = [
    https://www.samba.org/ftp/
    http://www.samba.org/ftp/
  ];

  # BitlBee mirrors, see https://www.bitlbee.org/main.php/mirrors.html .
  bitlbee = [
    http://get.bitlbee.org/
    http://get.bitlbee.be/
    http://get.us.bitlbee.org/
    http://ftp.snt.utwente.nl/pub/software/bitlbee/
    http://bitlbee.intergenia.de/
  ];

  # ImageMagick mirrors, see https://www.imagemagick.org/script/mirror.php
  imagemagick = [
    https://www.imagemagick.org/download/
    https://mirror.checkdomain.de/imagemagick/
    https://ftp.nluug.nl/ImageMagick/
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
    https://cpan.metacpan.org/
    https://cpan.perl.org/
    http://backpan.perl.org/  # for old releases
  ];

  # CentOS.
  centos = [
    http://mirror.centos.org/centos/
    # For old releases
    http://vault.centos.org/
    https://archive.kernel.org/centos-vault/
    http://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/
    http://mirrors.aliyun.com/centos-vault/
    https://mirror.chpc.utah.edu/pub/vault.centos.org/
    https://mirror.its.sfu.ca/mirror/CentOS-vault/
    https://mirror.math.princeton.edu/pub/centos-vault/
    https://mirrors.tripadvisor.com/centos-vault/
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
    https://xorg.freedesktop.org/releases/
    https://ftp.x.org/archive/
  ];

  # Apache mirrors (see http://www.apache.org/mirrors/).
  apache = [
    https://www-eu.apache.org/dist/
    https://www-us.apache.org/dist/
    http://www.eu.apache.org/dist/
    ftp://ftp.fu-berlin.de/unix/www/apache/
    http://ftp.tudelft.nl/apache/
    http://mirror.cc.columbia.edu/pub/software/apache/
    https://www.apache.org/dist/
    https://archive.apache.org/dist/ # fallback for old releases
    ftp://ftp.funet.fi/pub/mirrors/apache.org/
    http://apache.cs.uu.nl/
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
    http://hackage.fpcomplete.com/package/
    http://objects-us-east-1.dream.io/hackage-mirror/package/
  ];

  # Roy marples mirrors
  roy = [
    http://roy.marples.name/downloads/
    http://roy.aydogan.net/
    http://cflags.cc/roy/
  ];

  # Sage mirrors (http://www.sagemath.org/mirrors.html)
  sageupstream = [
    # Africa
    http://sagemath.polytechnic.edu.na/spkg/upstream/
    ftp://ftp.sun.ac.za/pub/mirrors/www.sagemath.org/spkg/upstream/
    http://sagemath.mirror.ac.za/spkg/upstream/
    https://ftp.leg.uct.ac.za/pub/packages/sage/spkg/upstream/
    http://mirror.ufs.ac.za/sagemath/spkg/upstream/

    # America, North
    http://mirrors-usa.go-parts.com/sage/sagemath/spkg/upstream/
    http://mirrors.mit.edu/sage/spkg/upstream/
    http://www.cecm.sfu.ca/sage/spkg/upstream/
    http://files.sagemath.org/spkg/upstream/
    http://mirror.clibre.uqam.ca/sage/spkg/upstream/
    https://mirrors.xmission.com/sage/spkg/upstream/

    # America, South
    http://sagemath.c3sl.ufpr.br/spkg/upstream/
    http://linorg.usp.br/sage/spkg/upstream

    # Asia
    http://sage.asis.io/spkg/upstream/
    http://mirror.hust.edu.cn/sagemath/spkg/upstream/
    https://ftp.iitm.ac.in/sage/spkg/upstream/
    http://ftp.kaist.ac.kr/sage/spkg/upstream/
    http://ftp.riken.jp/sagemath/spkg/upstream/
    https://mirrors.tuna.tsinghua.edu.cn/sagemath/spkg/upstream/
    https://mirrors.ustc.edu.cn/sagemath/spkg/upstream/
    http://ftp.tsukuba.wide.ad.jp/software/sage/spkg/upstream/
    http://ftp.yz.yamagata-u.ac.jp/pub/math/sage/spkg/upstream/
    https://mirror.yandex.ru/mirrors/sage.math.washington.edu/spkg/upstream/

    # Australia
    http://echidna.maths.usyd.edu.au/sage/spkg/upstream/

    # Europe
    http://sage.mirror.garr.it/mirrors/sage/spkg/upstream/
    http://sunsite.rediris.es/mirror/sagemath/spkg/upstream/
    http://mirror.switch.ch/mirror/sagemath/spkg/upstream/
    http://mirrors.fe.up.pt/pub/sage/spkg/upstream/
    http://www-ftp.lip6.fr/pub/math/sagemath/spkg/upstream/
    http://ftp.ntua.gr/pub/sagemath/spkg/upstream/
  ];

  # MySQL mirrors
  mysql = [
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
    https://public.abbradar.moe/steamrt/
  ];

  # Python PyPI mirrors
  pypi = [
    https://files.pythonhosted.org/packages/source/
    # pypi.io is a more semantic link, but atm it’s referencing
    # files.pythonhosted.org over two redirects
    https://pypi.io/packages/source/
  ];

  # Mozilla projects.
  mozilla = [
    http://download.cdn.mozilla.net/pub/mozilla.org/
    https://archive.mozilla.org/pub/
  ];

  # Maven Central
  maven = [
    https://repo1.maven.org/maven2/
    https://central.maven.org/maven2/
  ];

  # Alsa Project
  alsa = [
    https://www.alsa-project.org/files/pub/
    ftp://ftp.alsa-project.org/pub/
    http://alsa.cybermirror.org/
    http://www.mirrorservice.org/sites/ftp.alsa-project.org/pub/
    http://alsa.mirror.fr/
  ];
}
