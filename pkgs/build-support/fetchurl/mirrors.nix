{

  # Content-addressable Nix mirrors
  hashedMirrors = [
    "https://tarballs.nixos.org"
  ];

  # Mirrors for mirror://site/filename URIs, where "site" is
  # "sourceforge", "gnu", etc.

  # Alsa Project
  alsa = [
    "https://www.alsa-project.org/files/pub/"
    "ftp://ftp.alsa-project.org/pub/"
    "http://alsa.cybermirror.org/"
    "http://www.mirrorservice.org/sites/ftp.alsa-project.org/pub/"
  ];

  # Apache
  apache = [
    "https://dlcdn.apache.org/"
    "https://www-eu.apache.org/dist/"
    "https://ftp.wayne.edu/apache/"
    "https://www.apache.org/dist/"
    "https://archive.apache.org/dist/" # fallback for old releases
    "https://apache.cs.uu.nl/"
    "https://apache.cs.utah.edu/"
    "http://ftp.tudelft.nl/apache/"
    "ftp://ftp.funet.fi/pub/mirrors/apache.org/"
  ];

  # Bioconductor mirrors (from https://bioconductor.org/about/mirrors/)
  # The commented-out ones don't seem to allow direct package downloads;
  # they serve error messages that result in hash mismatches instead
  bioc = [
    # http://bioc.ism.ac.jp/
    # http://bioc.openanalytics.eu/
    # http://bioconductor.fmrp.usp.br/
    # http://mirror.aarnet.edu.au/pub/bioconductor/
    # http://watson.nci.nih.gov/bioc_mirror/
    "https://bioconductor.statistik.tu-dortmund.de/packages/"
    "https://mirrors.ustc.edu.cn/bioc/"
    "http://bioconductor.jp/packages/"
  ];

  # CRAN mirrors
  cran = [
    "https://cran.r-project.org/src/contrib/"
  ];

  # BitlBee mirrors, see https://www.bitlbee.org/main.php/mirrors.html
  bitlbee = [
    "https://get.bitlbee.org/"
    "https://ftp.snt.utwente.nl/pub/software/bitlbee/"
    "http://bitlbee.intergenia.de/"
  ];

  # GCC
  gcc = [
    "https://mirror.koddos.net/gcc/"
    "https://bigsearcher.com/mirrors/gcc/"
    "ftp://ftp.nluug.nl/mirror/languages/gcc/"
    "ftp://ftp.fu-berlin.de/unix/languages/gcc/"
    "ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/"
    "ftp://gcc.gnu.org/pub/gcc/"
  ];

  # GNOME
  gnome = [
    # This one redirects to some mirror closeby, so it should be all you need
    "https://download.gnome.org/"

    "https://fr2.rpmfind.net/linux/gnome.org/"
    "https://ftp.acc.umu.se/pub/GNOME/"
    "https://ftp.belnet.be/mirror/ftp.gnome.org/"
    "ftp://ftp.cse.buffalo.edu/pub/Gnome/"
    "ftp://ftp.nara.wide.ad.jp/pub/X11/GNOME/"
  ];

  # GNU (https://www.gnu.org/prep/ftp.html)
  gnu = [
    # This one redirects to a (supposedly) nearby and (supposedly) up-to-date
    # mirror
    "https://ftpmirror.gnu.org/"

    "https://ftp.nluug.nl/pub/gnu/"
    "https://mirrors.kernel.org/gnu/"
    "https://mirror.ibcp.fr/pub/gnu/"
    "https://mirror.dogado.de/gnu/"
    "https://mirror.tochlab.net/pub/gnu/"

    # This one is the master repository, and thus it's always up-to-date
    "https://ftp.gnu.org/pub/gnu/"

    "ftp://ftp.funet.fi/pub/mirrors/ftp.gnu.org/gnu/"
  ];

  # GnuPG
  gnupg = [
    "https://gnupg.org/ftp/gcrypt/"
    "https://mirrors.dotsrc.org/gcrypt/"
    "https://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/"
    "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/"
    "http://www.ring.gr.jp/pub/net/"
  ];

  # IBiblio (former metalab/sunsite)
  # Most of the time the expressions refer to the /pub/Linux/ subdirectory;
  # however there are other useful files outside it
  ibiblioPubLinux = [
    "https://www.ibiblio.org/pub/Linux/"
    "ftp://ftp.ibiblio.org/pub/linux/"
    "ftp://ftp.gwdg.de/pub/linux/metalab/"
    "ftp://ftp.metalab.unc.edu/pub/linux/"
  ];

  # ImageMagick mirrors, see https://www.imagemagick.org/script/mirror.php
  imagemagick = [
    "https://www.imagemagick.org/download/"
    "https://mirror.checkdomain.de/imagemagick/"
    "https://ftp.nluug.nl/ImageMagick/"
    "https://ftp.sunet.se/mirror/imagemagick.org/ftp/"
    "ftp://ftp.sunet.se/mirror/imagemagick.org/ftp/" # also contains older versions removed from most mirrors
  ];

  kde = [
    "https://download.kde.org/"
    "https://ftp.funet.fi/pub/mirrors/ftp.kde.org/pub/kde/"
  ];

  # kernel.org's /pub (/pub/{linux,software}) tree
  kernel = [
    "https://cdn.kernel.org/pub/"
    "http://linux-kernel.uio.no/pub/"
    "ftp://ftp.funet.fi/pub/mirrors/ftp.kernel.org/pub/"
  ];

  # MySQL
  mysql = [
    "https://cdn.mysql.com/Downloads/"
  ];

  # Maven Central
  maven = [
    "https://repo1.maven.org/maven2/"
  ];

  # Mozilla projects
  mozilla = [
    "https://download.cdn.mozilla.net/pub/mozilla.org/"
    "https://archive.mozilla.org/pub/"
  ];

  # OSDN (formerly SourceForge.jp)
  osdn = [
    "https://osdn.dl.osdn.jp/"
    "https://osdn.mirror.constant.com/"
    "https://mirrors.gigenet.com/OSDN/"
    "https://osdn.dl.sourceforge.jp/"
    "https://jaist.dl.sourceforge.jp/"
  ];

  # PostgreSQL
  postgresql = [
    "https://ftp.postgresql.org/pub/"
  ];

  # Qt
  qt = [
    "https://download.qt.io/"
  ];

  # Sage mirrors (https://www.sagemath.org/mirrors.html)
  sageupstream = [
    # Africa (HTTPS)
    "https://sagemath.mirror.ac.za/spkg/upstream/"
    "https://mirror.ufs.ac.za/sagemath/spkg/upstream/"

    # America, North (HTTPS)
    "https://mirrors.mit.edu/sage/spkg/upstream/"
    "https://mirrors.xmission.com/sage/spkg/upstream/"

    # Asia (HTTPS)
    "https://mirrors.tuna.tsinghua.edu.cn/sagemath/spkg/upstream/"
    "https://mirrors.ustc.edu.cn/sagemath/spkg/upstream/"
    "http://ftp.tsukuba.wide.ad.jp/software/sage/spkg/upstream/"
    "https://ftp.yz.yamagata-u.ac.jp/pub/math/sage/spkg/upstream/"
    "https://mirror.yandex.ru/mirrors/sage.math.washington.edu/spkg/upstream/"

    # Australia (HTTPS)
    "https://mirror.aarnet.edu.au/pub/sage/spkg/upstream/"

    # Europe (HTTPS)
    "https://sage.mirror.garr.it/mirrors/sage/spkg/upstream/"
    "https://www-ftp.lip6.fr/pub/math/sagemath/spkg/upstream/"

    # Africa (non-HTTPS)
    "ftp://ftp.sun.ac.za/pub/mirrors/www.sagemath.org/spkg/upstream/"

    # America, North (non-HTTPS)
    "http://www.cecm.sfu.ca/sage/spkg/upstream/"

    # America, South (non-HTTPS)
    "http://sagemath.c3sl.ufpr.br/spkg/upstream/"
    "http://linorg.usp.br/sage/spkg/upstream"

    # Asia (non-HTTPS)
    "http://ftp.kaist.ac.kr/sage/spkg/upstream/"
    "http://ftp.riken.jp/sagemath/spkg/upstream/"

    # Europe (non-HTTPS)
    "http://mirrors.fe.up.pt/pub/sage/spkg/upstream/"
    "http://ftp.ntua.gr/pub/sagemath/spkg/upstream/"
  ];

  # SAMBA
  samba = [
    "https://www.samba.org/ftp/"
    "http://www.samba.org/ftp/"
  ];

  # GNU Savannah
  savannah = [
    # Mirrors from https://download-mirror.savannah.gnu.org/releases/00_MIRRORS.html
    "https://mirror.easyname.at/nongnu/"
    "https://savannah.c3sl.ufpr.br/"
    "https://mirror.csclub.uwaterloo.ca/nongnu/"
    "https://mirror.cedia.org.ec/nongnu/"
    "https://ftp.igh.cnrs.fr/pub/nongnu/"
    "https://mirror6.layerjet.com/nongnu"
    "https://mirror.netcologne.de/savannah/"
    "https://ftp.cc.uoc.gr/mirrors/nongnu.org/"
    "https://nongnu.uib.no/"
    "https://ftp.acc.umu.se/mirror/gnu.org/savannah/"
    "http://mirror2.klaus-uwe.me/nongnu/"
    "http://mirrors.fe.up.pt/pub/nongnu/"
    "http://ftp.twaren.net/Unix/NonGNU/"
    "http://savannah-nongnu-org.ip-connect.vn.ua/"
    "http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/"
    "http://gnu.mirrors.pair.com/savannah/savannah/"
    "ftp://mirror.easyname.at/nongnu/"
    "ftp://mirror2.klaus-uwe.me/nongnu/"
    "ftp://mirror.csclub.uwaterloo.ca/nongnu/"
    "ftp://ftp.igh.cnrs.fr/pub/nongnu/"
    "ftp://mirror.netcologne.de/savannah/"
    "ftp://nongnu.uib.no/pub/nongnu/"
    "ftp://mirrors.fe.up.pt/pub/nongnu/"
    "ftp://ftp.twaren.net/Unix/NonGNU/"
    "ftp://savannah-nongnu-org.ip-connect.vn.ua/mirror/savannah.nongnu.org/"
    "ftp://ftp.mirrorservice.org/sites/download.savannah.gnu.org/releases/"
  ];

  # SourceForge
  sourceforge = [
    "https://downloads.sourceforge.net/"
    "https://prdownloads.sourceforge.net/"
    "https://netcologne.dl.sourceforge.net/sourceforge/"
    "https://versaweb.dl.sourceforge.net/sourceforge/"
    "https://freefr.dl.sourceforge.net/sourceforge/"
    "https://osdn.dl.sourceforge.net/sourceforge/"
  ];

  # Steam Runtime
  steamrt = [
    "https://repo.steampowered.com/steamrt/"
    "https://public.abbradar.moe/steamrt/"
  ];

  # TCSH shell
  tcsh = [
    "https://astron.com/pub/tcsh/"
    "https://astron.com/pub/tcsh/old/"
    "http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/"
    "http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/old/"
    "ftp://ftp.astron.com/pub/tcsh/"
    "ftp://ftp.astron.com/pub/tcsh/old/"
    "ftp://ftp.funet.fi/pub/unix/shells/tcsh/"
    "ftp://ftp.funet.fi/pub/unix/shells/tcsh/old/"
  ];

  # XFCE
  xfce = [
    "https://archive.xfce.org/"
    "https://mirror.netcologne.de/xfce/"
    "https://archive.be.xfce.org/xfce/"
    "https://archive.al-us.xfce.org/"
    "http://archive.se.xfce.org/xfce/"
    "http://mirror.perldude.de/archive.xfce.org/"
    "http://archive.be2.xfce.org/"
    "http://ftp.udc.es/xfce/"
  ];

  # X.org
  xorg = [
    "https://xorg.freedesktop.org/releases/"
    "https://ftp.x.org/archive/"
  ];

  ### Programming languages' package repos

  # Perl CPAN
  cpan = [
    "https://cpan.metacpan.org/"
    "https://cpan.perl.org/"
    "https://mirrors.kernel.org/CPAN/"
    "https://backpan.perl.org/" # for old releases
  ];

  # D DUB
  dub = [
    "https://code.dlang.org/packages/"
    "https://codemirror.dlang.org/packages/"
  ];

  # Haskell Hackage
  hackage = [
    "https://hackage.haskell.org/package/"
  ];

  # Lua Rocks
  luarocks = [
    "https://luarocks.org/"
    "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/"
    "https://luafr.org/moonrocks/"
  ];

  # Python PyPI
  pypi = [
    "https://files.pythonhosted.org/packages/source/"
    # pypi.io is a more semantic link, but atm it’s referencing
    # files.pythonhosted.org over two redirects
    "https://pypi.io/packages/source/"
  ];

  # Python Test-PyPI
  testpypi = [
    "https://test.pypi.io/packages/source/"
  ];

  ### Linux distros

  # CentOS
  centos = [
    # For old releases
    "https://vault.centos.org/"
    "https://archive.kernel.org/centos-vault/"
    "https://ftp.jaist.ac.jp/pub/Linux/CentOS-vault/"
    "https://mirrors.aliyun.com/centos-vault/"
    "https://mirror.chpc.utah.edu/pub/vault.centos.org/"
    "https://mirror.math.princeton.edu/pub/centos-vault/"
    "https://mirrors.tripadvisor.com/centos-vault/"
    "http://mirror.centos.org/centos/"
  ];

  # Debian
  debian = [
    "https://httpredir.debian.org/debian/"
    "https://ftp.debian.org/debian/"
    "https://mirrors.edge.kernel.org/debian/"
    "ftp://ftp.de.debian.org/debian/"
    "ftp://ftp.fr.debian.org/debian/"
    "ftp://ftp.nl.debian.org/debian/"
    "ftp://ftp.ru.debian.org/debian/"
    "http://archive.debian.org/debian-archive/debian/"
    "ftp://ftp.funet.fi/pub/mirrors/ftp.debian.org/debian/"
  ];

  # Fedora
  # Please add only full mirrors that carry old Fedora distributions as well
  # See: https://mirrors.fedoraproject.org/publiclist (but not all carry old content)
  fedora = [
    "https://archives.fedoraproject.org/pub/fedora/"
    "https://fedora.osuosl.org/"
    "https://ftp.funet.fi/pub/mirrors/ftp.redhat.com/pub/fedora/"
    "https://ftp.linux.cz/pub/linux/fedora/"
    "https://archives.fedoraproject.org/pub/archive/fedora/"
    "http://ftp.nluug.nl/pub/os/Linux/distr/fedora/"
    "http://mirror.csclub.uwaterloo.ca/fedora/"
    "http://mirror.1000mbps.com/fedora/"
  ];

  # Gentoo
  gentoo = [
    "https://ftp.snt.utwente.nl/pub/os/linux/gentoo/"
    "https://distfiles.gentoo.org/"
    "https://mirrors.kernel.org/gentoo/"
  ];

  # openSUSE
  opensuse = [
    "https://opensuse.hro.nl/opensuse/distribution/"
    "https://ftp.funet.fi/pub/linux/mirrors/opensuse/distribution/"
    "https://ftp.opensuse.org/pub/opensuse/distribution/"
    "https://ftp5.gwdg.de/pub/opensuse/discontinued/distribution/"
    "https://mirrors.edge.kernel.org/opensuse/distribution/"
    "http://ftp.hosteurope.de/mirror/ftp.opensuse.org/discontinued/"
  ];

  # Ubuntu
  ubuntu = [
    "https://nl.archive.ubuntu.com/ubuntu/"
    "https://old-releases.ubuntu.com/ubuntu/"
    "https://mirrors.edge.kernel.org/ubuntu/"
    "http://de.archive.ubuntu.com/ubuntu/"
    "http://archive.ubuntu.com/ubuntu/"
  ];

  # ... and other OSes in general

  # OpenBSD
  openbsd = [
    "https://ftp.openbsd.org/pub/OpenBSD/"
    "ftp://ftp.nluug.nl/pub/OpenBSD/"
    "ftp://ftp-stud.fht-esslingen.de/pub/OpenBSD/"
  ];
}
