{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  bison,
  flex,
  which,
  perl,
  python3,
  makeWrapper,
  binutils,
  zlib,
  ncurses,
  readline,
  openssl,
  libuv,
  cyrus_sasl,
  inih,
  xz,
  rrdtool,
  avahi,
  lvm2,
  systemd,
  libpfm,
  libbpf,
  bcc,
  elfutils,
  net-snmp,
  llvmPackages,
  perlPackages,
  nixosTests,
  withSystemd ? stdenv.hostPlatform.isLinux,
  withPfm ? stdenv.hostPlatform.isLinux,
  withBpf ? false,
  withSnmp ? true,
}:

stdenv.mkDerivation {
  pname = "pcp";
  version = "7.1.1-unstable-2026-03-01";

  # Pulled from main branch on 2026-03-01; upstream does not tag releases
  # consistently, so we pin to a specific commit.
  src = fetchFromGitHub {
    owner = "performancecopilot";
    repo = "pcp";
    rev = "ad0044acb826e14d7fa94e86fafcc40822cc7e1a";
    hash = "sha256-a5ogs7ORmPLUecju6qJcZtjWhRj3Wtx2v3rmOuqtLM0=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    bison
    flex
    which
    perl
    python3
    python3.pkgs.setuptools
    makeWrapper
    binutils
  ]
  ++ lib.optionals withBpf [
    llvmPackages.clang
    llvmPackages.llvm
  ];

  buildInputs = [
    zlib
    ncurses
    readline
    openssl
    libuv
    cyrus_sasl
    inih
    xz
    python3
    perl
    rrdtool
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    avahi
    lvm2
  ]
  ++ lib.optionals withSystemd [
    systemd
  ]
  ++ lib.optionals withPfm [
    libpfm
  ]
  ++ lib.optionals withBpf [
    libbpf
    bcc
    elfutils
  ]
  ++ lib.optionals withSnmp [
    net-snmp
  ]
  ++ [
    python3.pkgs.requests
    perlPackages.JSON
    perlPackages.LWP
  ];

  configureFlags = lib.concatLists [
    [
      "--prefix=${placeholder "out"}"
      "--sysconfdir=${placeholder "out"}/etc"
      "--localstatedir=${placeholder "out"}/var"
      "--with-rcdir=${placeholder "out"}/etc/init.d"
      "--with-tmpdir=/tmp"
      "--with-logdir=${placeholder "out"}/var/log/pcp"
      "--with-rundir=/run/pcp"
    ]
    [
      "--with-user=pcp"
      "--with-group=pcp"
    ]
    [
      "--with-make=make"
      "--with-tar=tar"
      "--with-python3=${lib.getExe python3}"
    ]
    [
      "--with-perl=yes"
      "--with-threads=yes"
    ]
    [
      "--with-secure-sockets=yes"
      "--with-transparent-decompression=yes"
    ]
    (if stdenv.hostPlatform.isLinux then [ "--with-discovery=yes" ] else [ "--with-discovery=no" ])
    [
      "--with-dstat-symlink=no"
      "--with-pmdamongodb=no"
      "--with-pmdamysql=no"
      "--with-pmdanutcracker=no"
      "--with-qt=no"
      "--with-infiniband=no"
      "--with-selinux=no"
    ]
    (if withSystemd then [ "--with-systemd=yes" ] else [ "--with-systemd=no" ])
    (if withPfm then [ "--with-perfevent=yes" ] else [ "--with-perfevent=no" ])
    (
      if withBpf then
        [
          "--with-pmdabcc=yes"
          "--with-pmdabpf=yes"
          "--with-pmdabpftrace=yes"
        ]
      else
        [
          "--with-pmdabcc=no"
          "--with-pmdabpf=no"
          "--with-pmdabpftrace=no"
        ]
    )
    (if stdenv.hostPlatform.isLinux then [ "--with-devmapper=yes" ] else [ "--with-devmapper=no" ])
    (if withSnmp then [ "--with-pmdasnmp=yes" ] else [ "--with-pmdasnmp=no" ])
  ];

  patches = [
    ./gnumakefile-nix-fixes.patch
    ./python-libpcp-nix.patch
    ./python-pmapi-no-reconnect.patch
    ./shell-portable-pwd.patch
    ./perl-install-path-fix.patch
  ];

  postPatch = ''
    patchShebangs src build configure scripts man
    for f in src/pmdas/bind2/mk.rewrite \
             src/pmdas/jbd2/mk.rewrite \
             src/pmdas/linux/mk.rewrite \
             src/pmdas/linux_proc/mk.rewrite; do
      if [ -f "$f" ]; then
        substituteInPlace "$f" --replace-quiet '/var/tmp' "$TMPDIR"
      fi
    done
  '';

  preConfigure = ''
    export AR="${stdenv.cc.bintools.bintools}/bin/ar"
  '';

  hardeningDisable = lib.optionals withBpf [ "zerocallusedregs" ];
  BPF_CFLAGS = lib.optionalString withBpf "-fno-stack-protector -Wno-error=unused-command-line-argument";
  CLANG = lib.optionalString withBpf (lib.getExe llvmPackages.clang);
  AR = "${stdenv.cc.bintools.bintools}/bin/ar";

  SYSTEMD_SYSTEMUNITDIR = lib.optionalString withSystemd "${placeholder "out"}/lib/systemd/system";
  SYSTEMD_TMPFILESDIR = lib.optionalString withSystemd "${placeholder "out"}/lib/tmpfiles.d";
  SYSTEMD_SYSUSERSDIR = lib.optionalString withSystemd "${placeholder "out"}/lib/sysusers.d";

  postInstall = ''
    (
      cd $out/var/lib/pcp/pmns
      export PCP_DIR=$out
      export PCP_CONF=$out/etc/pcp.conf
      . $out/etc/pcp.env
      $out/libexec/pcp/bin/pmnsmerge -a \
        $(ls $out/libexec/pcp/pmns/root_* | sort) \
        root
    )
    rm -rf $out/var/{run,log} $out/var/lib/pcp/tmp || true
    rm -f $out/var/lib/pcp/config/derived/mssql.conf || true
    if [ -d "$out/etc" ]; then
      mkdir -p $out/share/pcp/etc
      mv $out/etc/* $out/share/pcp/etc/
      rmdir $out/etc || true
      substituteInPlace $out/share/pcp/etc/pcp.conf \
        --replace-quiet "$out/etc/pcp" "$out/share/pcp/etc/pcp" \
        --replace-quiet "$out/etc/sysconfig" "$out/share/pcp/etc/sysconfig" \
        --replace-quiet "PCP_ETC_DIR=$out/etc" "PCP_ETC_DIR=$out/share/pcp/etc"
      find $out/var/lib/pcp -type l | while read link; do
        target=$(readlink "$link")
        if [[ "$target" == *"/etc/pcp/"* ]]; then
          suffix="''${target#*/etc/pcp/}"
          rm "$link"
          ln -sf "$out/share/pcp/etc/pcp/$suffix" "$link"
        fi
      done
    fi
    for broken_link in "$out/share/pcp/etc/pcp/pm"{search/pmsearch,series/pmseries}.conf; do
      [[ -L "$broken_link" ]] && rm "$broken_link" && \
        ln -sf "$out/share/pcp/etc/pcp/pmproxy/pmproxy.conf" "$broken_link"
    done
    if [[ -L "$out/share/pcp/etc/pcp/pmcd/rc.local" ]]; then
      rm "$out/share/pcp/etc/pcp/pmcd/rc.local"
      ln -sf "$out/libexec/pcp/services/local" "$out/share/pcp/etc/pcp/pmcd/rc.local"
    fi
    for procconf in $out/share/pcp/etc/pcp/derived/proc.conf $out/var/lib/pcp/config/derived/proc.conf; do
      if [ -f "$procconf" ]; then
        sed -i -e 's/novalue(type=u64, semantics=counter, units=Kbyte, indom=157\.2)/novalue(type=u64,semantics=counter,units=Kbyte)/g' \
               -e 's/novalue(type=u64,semantics=counter,units=Kbyte,indom=157\.2)/novalue(type=u64,semantics=counter,units=Kbyte)/g' "$procconf"
      fi
    done
    for pmda_dir in $out/libexec/pcp/pmdas/*/; do
      for pyfile in "$pmda_dir"*.python; do
        if [ -f "$pyfile" ]; then
          base=$(basename "$pyfile" .python)
          pylink="$pmda_dir$base.py"
          if [ ! -e "$pylink" ]; then
            ln -s "$(basename "$pyfile")" "$pylink"
          fi
        fi
      done
    done
    find $out/libexec/pcp/pmdas -name "*.python" -type f 2>/dev/null | while read pyfile; do
      base=$(basename "$pyfile" .python)
      pylink="$(dirname "$pyfile")/$base.py"
      if [ ! -e "$pylink" ]; then
        ln -s "$(basename "$pyfile")" "$pylink"
      fi
    done
    find $out/var/lib/pcp/pmdas -name "*.python" -type l 2>/dev/null | while read pyfile; do
      base=$(basename "$pyfile" .python)
      pylink="$(dirname "$pyfile")/$base.py"
      if [ ! -e "$pylink" ]; then
        ln -s "$(basename "$pyfile")" "$pylink"
      fi
    done
    if [ -d "$out/share/man" ]; then
      mkdir -p $man/share
      mv $out/share/man $man/share/
    fi
    for docdir in $out/share/doc/pcp*; do
      if [ -d "$docdir" ]; then
        mkdir -p $doc/share/doc
        mv "$docdir" $doc/share/doc/
      fi
    done
  '';

  postFixup = ''
    for script in $out/libexec/pcp/bin/pcp-*; do
      if head -1 "$script" 2>/dev/null | grep -q python; then
        wrapProgram "$script" \
          --set PCP_DIR "$out/share/pcp" \
          --prefix PYTHONPATH : "$out/lib/${python3.libPrefix}/site-packages" \
          --prefix LD_LIBRARY_PATH : "$out/lib"
      fi
    done
    if [ -f "$out/bin/pmpython" ]; then
      wrapProgram "$out/bin/pmpython" \
        --set PCP_DIR "$out/share/pcp" \
        --prefix PYTHONPATH : "$out/lib/${python3.libPrefix}/site-packages" \
        --prefix LD_LIBRARY_PATH : "$out/lib"
    fi
    if [ -f "$out/bin/pcp" ]; then
      wrapProgram "$out/bin/pcp" \
        --set PCP_DIR "$out/share/pcp" \
        --prefix PYTHONPATH : "$out/lib/${python3.libPrefix}/site-packages" \
        --prefix LD_LIBRARY_PATH : "$out/lib"
    fi
  '';

  doCheck = false;
  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) pcp;
  };

  meta = {
    description = "Performance Co-Pilot - system performance monitoring toolkit";
    homepage = "https://pcp.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    # maintainers = with lib.maintainers; [ randomizedcoder ];
    mainProgram = "pminfo";
  };
}
