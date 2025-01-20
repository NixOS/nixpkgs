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
stdenv.mkDerivation rec {
  pname = "shorewall";
  version = "5.2.3.3";

  srcs = [
    (fetchurl {
      url = "http://www.shorewall.net/pub/shorewall/5.2/shorewall-5.2.3/shorewall-core-${version}.tar.bz2";
      sha256 = "1gg2yfxzm3y9qqjrrg5nq2ggi1c6yfxx0s7fvwjw70b185mwa5p5";
    })
    (fetchurl {
      url = "http://www.shorewall.net/pub/shorewall/5.2/shorewall-5.2.3/shorewall-${version}.tar.bz2";
      sha256 = "1ka70pa3s0cnvc83rlm57r05cdv9idnxnq0vmxi6nr7razak5f3b";
    })
    (fetchurl {
      url = "http://www.shorewall.net/pub/shorewall/5.2/shorewall-5.2.3/shorewall6-${version}.tar.bz2";
      sha256 = "0mhs4m6agwk082h1n69gnyfsjpycdd8215r4r9rzb3czs5xi087n";
    })
  ];
  sourceRoot = ".";

  buildInputs =
    [
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
    sed -i shorewall-core-${version}/lib.cli \
        -e '/^ *PATH=.*/d'
  '';
  configurePhase = ''
    shorewall-core-${version}/configure \
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
    shorewall-core-${version}/install.sh

    ln -s ../shorewall-core-${version}/shorewallrc shorewall-${version}/
    shorewall-${version}/install.sh

    ln -s ../shorewall-core-${version}/shorewallrc shorewall6-${version}/
    shorewall6-${version}/install.sh

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
    homepage = "http://www.shorewall.net/";
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
}
