{
  coreutils,
  fetchurl,
  gnugrep,
  gnused,
  iproute2,
  iptables,
  perl,
  perlPackages,
  lib,
  stdenv,
  util-linux,
}:
let
  PATH = lib.concatStringsSep ":" [
    "${coreutils}/bin"
    "${iproute2}/bin"
    "${iptables}/bin"
    "${util-linux}/bin"
    "${gnugrep}/bin"
    "${gnused}/bin"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shorewall";
  version = "5.2.8";

  srcs = [
    (fetchurl {
      url = "https://shorewall.org/pub/shorewall/5.2/shorewall-5.2.8/shorewall-core-${finalAttrs.version}.tar.bz2";
      hash = "sha256-OZlrlpeiAXlHBJrT8DyyeOj5Of+SSyu0vyoLwXxZmI4=";
    })
    (fetchurl {
      url = "https://shorewall.org/pub/shorewall/5.2/shorewall-5.2.8/shorewall-${finalAttrs.version}.tar.bz2";
      hash = "sha256-+7WrSS7TcuqvAoF8xzD4LEmoHFpfXO5LyPG86EbyMG0=";
    })
    (fetchurl {
      url = "https://shorewall.org/pub/shorewall/5.2/shorewall-5.2.8/shorewall6-${finalAttrs.version}.tar.bz2";
      hash = "sha256-6Cw6lTi2VIGVOY3DnIOwG89m61oigUyRWpJLmtwIjNE=";
    })
  ];
  sourceRoot = ".";

  buildInputs = [
    coreutils
    iproute2
    iptables
    util-linux
    gnugrep
    gnused
    perl
  ]
  ++ (with perlPackages; [
    DigestSHA1
  ]);
  prePatch = ''
    # Patch configure and install.sh files
    patchShebangs .

    # Remove hardcoded PATH
    sed -i shorewall-core-${finalAttrs.version}/lib.cli \
        -e '/^ *PATH=.*/d'
  '';
  configurePhase = ''
    shorewall-core-${finalAttrs.version}/configure \
      HOST=linux \
      PREFIX=$out \
      CONFDIR=\$PREFIX/etc-example \
      SBINDIR=\$PREFIX/sbin \
      SYSCONFDIR= \
      SHAREDIR=\$PREFIX/share \
      LIBEXECDIR=\$SHAREDIR \
      PERLLIBDIR=\$SHAREDIR/shorewall \
      MANDIR=$out/man \
      VARLIB=/var/lib \
      INITSOURCE= \
      INITDIR= \
      INITFILE= \
      DEFAULT_PAGER=
  '';
  installPhase = ''
    export DESTDIR=/
    shorewall-core-${finalAttrs.version}/install.sh

    ln -s ../shorewall-core-${finalAttrs.version}/shorewallrc shorewall-${finalAttrs.version}/
    shorewall-${finalAttrs.version}/install.sh

    ln -s ../shorewall-core-${finalAttrs.version}/shorewallrc shorewall6-${finalAttrs.version}/
    shorewall6-${finalAttrs.version}/install.sh

    # Patch the example shorewall{,6}.conf in case it is included
    # in services.shorewall{,6}.configs
    sed -i $out/etc-example/shorewall/shorewall.conf \
           $out/etc-example/shorewall6/shorewall6.conf \
        -e 's|^LOGFILE=.*|LOGFILE=/var/log/shorewall.log|' \
        -e 's|^PATH=.*|PATH=${PATH}|' \
        -e 's|^PERL=.*|PERL=${perl}/bin/perl|' \
        -e 's|^SHOREWALL_SHELL=.*|SHOREWALL_SHELL=${stdenv.shell}|'
    sed -i $out/etc-example/shorewall6/shorewall6.conf \
        -e 's|^CONFIG_PATH=.*|CONFIG_PATH=:''${CONFDIR}/shorewall6:''${SHAREDIR}/shorewall6:''${SHAREDIR}/shorewall|'
    # FIXME: the default GEOIPDIR=/usr/share/xt_geoip/LE may require attention.

    # Redirect CONFDIR to /etc where services.shorewall{,6}.configs
    # will generate the config files.
    sed -i $out/share/shorewall/shorewallrc \
        -e 's~^CONFDIR=.*~CONFDIR=/etc~'
  '';

  meta = {
    homepage = "https://shorewall.org/";
    description = "IP gateway/firewall configuration tool for GNU/Linux";
    longDescription = ''
      Shorewall is a high-level tool for configuring Netfilter. You describe your
      firewall/gateway requirements using entries in a set of configuration
      files. Shorewall reads those configuration files and with the help of the
      iptables, iptables-restore, ip and tc utilities, Shorewall configures
      Netfilter and the Linux networking subsystem to match your requirements.
      Shorewall can be used on a dedicated firewall system, a multi-function
      gateway/router/server or on a standalone GNU/Linux system. Shorewall does
      not use Netfilter's ipchains compatibility mode and can thus take
      advantage of Netfilter's connection state tracking capabilities.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
