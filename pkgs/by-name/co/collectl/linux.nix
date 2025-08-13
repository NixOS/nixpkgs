{
  lib,
  stdenv,
  fetchurl,
  perl,
  gzip,
  coreutils,
  gnugrep,
  inetutils,
  openssh,

  pname,
  version,
  meta,
  passthru,
}:

stdenv.mkDerivation rec {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://sourceforge.net/projects/collectl/files/collectl-${version}.src.tar.gz/download";
    name = "collectl-${version}.src.tar.gz";
    sha256 = "2187264d974b36a653c8a4b028ac6eeab23e1885f8b2563a33f06358f39889f1";
  };

  nativeBuildInputs = [ gzip ];

  buildInputs = [ perl ];

  propagatedBuildInputs = [
    coreutils # provides hostname, cat, and other utilities
    gnugrep # provides grep
    inetutils # provides ping
    openssh # provides ssh
  ];

  # No build phase needed - these are Perl scripts
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Define directory variables following INSTALL script style
    BINDIR=$out/bin
    DOCDIR=$out/share/doc/collectl
    SHRDIR=$out/share/collectl
    MANDIR=$out/share/man/man1
    ETCDIR=$out/etc
    LOGDIR=$out/var/log/collectl

    # Create directory structure
    mkdir -p $BINDIR
    mkdir -p $DOCDIR
    mkdir -p $SHRDIR
    mkdir -p $MANDIR
    mkdir -p $ETCDIR
    mkdir -p $SHRDIR/util
    mkdir -p $LOGDIR

    # Install main executables
    cp collectl colmux $BINDIR

    # Install configuration
    cp collectl.conf $ETCDIR

    # Install documentation
    cp docs/* $DOCDIR
    cp GPL ARTISTIC COPYING RELEASE-collectl $DOCDIR

    # Install Perl modules and utilities
    cp UNINSTALL $SHRDIR
    cp formatit.ph lexpr.ph gexpr.ph misc.ph $SHRDIR
    cp hello.ph graphite.ph envrules.std statsd.ph $SHRDIR
    cp vmstat.ph vnet.ph vmsum.ph $SHRDIR
    cp client.pl $SHRDIR/util

    # Install and compress man pages
    cp man1/* $MANDIR
    gzip -f $MANDIR/collectl*

    # Set permissions
    chmod 755 $BINDIR/collectl $BINDIR/colmux
    chmod 444 $ETCDIR/collectl.conf
    chmod 444 $SHRDIR/*.ph
    chmod 755 $SHRDIR/util/*

    runHook postInstall
  '';

  # Patch hardcoded paths to system utilities
  postFixup = ''
    # Patch hardcoded paths in collectl
    substituteInPlace $out/bin/collectl \
      --replace-fail "'/bin/cat'" "'${coreutils}/bin/cat'" \
      --replace-fail "'/bin/grep'" "'${gnugrep}/bin/grep'" \
      --replace-fail '`/bin/hostname`' '`${inetutils}/bin/hostname`' \
      --replace-fail '`hostname`' '`${inetutils}/bin/hostname`' \
      --replace-fail '$configFile="$BinDir/$ConfigFile;$etcDir/$ConfigFile";' '$configFile="$BinDir/../etc/$ConfigFile;$etcDir/$ConfigFile";'

    # Patch hardcoded paths in colmux
    substituteInPlace $out/bin/colmux \
      --replace-fail "'/bin/ping'" "'${inetutils}/bin/ping'" \
      --replace-fail "'/bin/grep'" "'${gnugrep}/bin/grep'" \
      --replace-fail '`hostname`' '`${inetutils}/bin/hostname`' \
      --replace-fail '/usr/bin/ssh' '${openssh}/bin/ssh'

    # Patch hardcoded paths in formatit.ph
    substituteInPlace $out/share/collectl/formatit.ph \
      --replace-fail '`hostname`' '`${inetutils}/bin/hostname`'

    # Patch hardcoded paths in graphite.ph
    substituteInPlace $out/share/collectl/graphite.ph \
      --replace-fail '`hostname`' '`${inetutils}/bin/hostname`' \
      --replace-fail '`hostname -f`' '`${inetutils}/bin/hostname -f`'

    # Patch hardcoded paths in vmsum.ph
    substituteInPlace $out/share/collectl/vmsum.ph \
      --replace-fail '`hostname`' '`${inetutils}/bin/hostname`'
  '';

}
