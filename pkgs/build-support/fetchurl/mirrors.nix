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
  ];

  # Apache
  apache = [
    "https://downloads.apache.org/"
    "https://archive.apache.org/dist/" # fallback for old releases
  ];

  # Bioconductor mirrors
  bioc = [
    # Served via CloudFront
    "https://bioconductor.org/packages/"
  ];

  # CRAN mirrors
  cran = [
    "https://cran.r-project.org/src/contrib/"
  ];

  # BitlBee mirrors, see https://www.bitlbee.org/main.php/mirrors.html
  bitlbee = [
    "https://get.bitlbee.org/"
  ];

  # GCC
  gcc = [
    "https://gcc.gnu.org/pub/gcc/"
  ];

  # GNOME
  gnome = [
    # This one redirects to some mirror closeby, so it should be all you need
    "https://download.gnome.org/"
  ];

  # GNU (https://www.gnu.org/prep/ftp.html)
  gnu = [
    # This one is the master repository, and thus it's always up-to-date
    "https://ftp.gnu.org/pub/gnu/"
  ];

  # GnuPG
  gnupg = [
    "https://gnupg.org/ftp/gcrypt/"
  ];

  # IBiblio (former metalab/sunsite)
  # Most of the time the expressions refer to the /pub/Linux/ subdirectory;
  # however there are other useful files outside it
  ibiblioPubLinux = [
    "https://www.ibiblio.org/pub/Linux/"
  ];

  kde = [
    "https://download.kde.org/"
  ];

  # kernel.org's /pub (/pub/{linux,software}) tree
  kernel = [
    "https://cdn.kernel.org/pub/"
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
    "https://archive.mozilla.org/pub/"
  ];

  # OSDN (formerly SourceForge.jp)
  osdn = [
    # The official servers are dead; packages should be moved off
    # or considered for dropping, but mirrors.dotsrc.org seems to
    # work for now.
    "https://mirrors.dotsrc.org/osdn/"
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
    "https://ftp.yz.yamagata-u.ac.jp/pub/math/sage/spkg/upstream/"
    "https://mirror.yandex.ru/mirrors/sage.math.washington.edu/spkg/upstream/"

    # Australia (HTTPS)
    "https://mirror.aarnet.edu.au/pub/sage/spkg/upstream/"

    # Europe (HTTPS)
    "https://sage.mirror.garr.it/mirrors/sage/spkg/upstream/"
    "https://www-ftp.lip6.fr/pub/math/sagemath/spkg/upstream/"
  ];

  # SAMBA
  samba = [
    "https://download.samba.org/pub/"
  ];

  # GNU Savannah
  savannah = [
    # Canonical upstream mirror without redirects
    "https://download-mirror.savannah.gnu.org/releases/"
  ];

  # SourceForge
  sourceforge = [
    "https://downloads.sourceforge.net/"
  ];

  # TCSH shell
  tcsh = [
    "https://astron.com/pub/tcsh/"
    "https://astron.com/pub/tcsh/old/"
  ];

  # XFCE
  xfce = [
    "https://archive.xfce.org/"
  ];

  # X.org
  xorg = [
    "https://www.x.org/releases/"
  ];

  ### Programming languages' package repos

  # Perl CPAN
  cpan = [
    "https://www.cpan.org/"
    "https://backpan.perl.org/" # for old releases
  ];

  # D DUB
  dub = [
    "https://code.dlang.org/packages/"
  ];

  # Haskell Hackage
  hackage = [
    "https://hackage.haskell.org/package/"
  ];

  # Lua Rocks
  luarocks = [
    "https://luarocks.org/"
  ];

  # Python PyPI
  pypi = [
    "https://files.pythonhosted.org/packages/source/"
  ];

  ### Linux distros

  # Debian
  debian = [
    "https://deb.debian.org/debian/"
    # For old releases
    "https://archive.debian.org/debian-archive/debian/"
  ];

  # Ubuntu
  ubuntu = [
    "https://archive.ubuntu.com/ubuntu/"
    "https://old-releases.ubuntu.com/ubuntu/"
  ];

  # ... and other OSes in general

  # OpenBSD
  openbsd = [
    "https://cdn.openbsd.org/pub/OpenBSD/"
  ];
}
