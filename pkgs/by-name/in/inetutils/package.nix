{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  ncurses,
  perl,
  help2man,
  apparmorRulesFromClosure,
  libxcrypt,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "inetutils";
  version = "2.7";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-oVa+HN48XA/+/CYhgNk2mmBIQIeQeqVUxieH0vQOwIY=";
  };

  outputs = [
    "out"
    "apparmor"
  ];

  patches = [
    # https://git.congatec.com/yocto/meta-openembedded/commit/3402bfac6b595c622e4590a8ff5eaaa854e2a2a3
    ./inetutils-1_9-PATH_PROCNET_DEV.patch

    ./tests-libls.sh.patch

    (fetchpatch {
      name = "CVE-2026-24061_1.patch";
      url = "https://codeberg.org/inetutils/inetutils/commit/fd702c02497b2f398e739e3119bed0b23dd7aa7b.patch";
      hash = "sha256-d/FdQyLD0gYr+erFqKDr8Okf04DFXknFaN03ls2aonQ=";
    })
    (fetchpatch {
      name = "CVE-2026-24061_2.patch";
      url = "https://codeberg.org/inetutils/inetutils/commit/ccba9f748aa8d50a38d7748e2e60362edd6a32cc.patch";
      hash = "sha256-ws+ed5vb7kVMHEbqK7yj6FUT355pTv2RZEYuXs5M7Io=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [
    help2man
    perl # for `whois'
  ];
  buildInputs = [
    ncurses # for `talk'
    libxcrypt
  ];

  # Don't use help2man if cross-compiling
  # https://lists.gnu.org/archive/html/bug-sed/2017-01/msg00001.html
  # https://git.congatec.com/yocto/meta-openembedded/blob/3402bfac6b595c622e4590a8ff5eaaa854e2a2a3/meta-networking/recipes-connectivity/inetutils/inetutils_1.9.1.bb#L44
  preConfigure =
    let
      isCross = stdenv.hostPlatform != stdenv.buildPlatform;
    in
    lib.optionalString isCross ''
      export HELP2MAN=true
    '';

  configureFlags = [
    "--with-ncurses-include-dir=${ncurses.dev}/include"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    # Musl doesn't define rcmd
    "--disable-rcp"
    "--disable-rsh"
    "--disable-rlogin"
    "--disable-rexec"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-servers";

  doCheck = true;

  installFlags = [ "SUIDMODE=" ];

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.ping <<EOF
    abi <abi/4.0>,
    include <tunables/global>
    profile $out/bin/ping {
      include <abstractions/base>
      include <abstractions/consoles>
      include <abstractions/nameservice>
      include "${apparmorRulesFromClosure { name = "ping"; } [ stdenv.cc.libc ]}"
      capability net_raw,
      network inet raw,
      network inet6 raw,
      mr $out/bin/ping,
      include if exists <local/bin.ping>
    }
    EOF
  '';

  meta = {
    description = "Collection of common network programs";

    longDescription = ''
      The GNU network utilities suite provides the
      following tools: ftp(d), hostname, ifconfig, inetd, logger, ping, rcp,
      rexec(d), rlogin(d), rsh(d), syslogd, talk(d), telnet(d), tftp(d),
      traceroute, uucpd, and whois.
    '';

    homepage = "https://www.gnu.org/software/inetutils/";
    license = lib.licenses.gpl3Plus;

    maintainers = with lib.maintainers; [ matthewbauer ];
    platforms = lib.platforms.unix;

    /**
      The `logger` binary from `util-linux` is preferred over `inetutils`.
      To instead prioritize this package, set a _lower_ `meta.priority`, or
      use e.g. `lib.setPrio 5 inetutils`.
    */
    priority = (util-linux.meta.priority or lib.meta.defaultPriority) + 1;
  };
}
