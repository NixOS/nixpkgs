{
  stdenv,
  lib,
  fetchurl,
  clang,
  llvm,
  pkg-config,
  makeWrapper,
  elfutils,
  file,
  hyperscan,
  jansson,
  libbpf,
  libcap_ng,
  libevent,
  libmaxminddb,
  libnet,
  libnetfilter_log,
  libnetfilter_queue,
  libnfnetlink,
  libpcap,
  libyaml,
  luajit,
  lz4,
  nspr,
  pcre2,
  python,
  zlib,
  redisSupport ? true,
  redis,
  hiredis,
  rustSupport ? true,
  rustc,
  cargo,
}:
let
  libmagic = file;
  hyperscanSupport = stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";
in
stdenv.mkDerivation rec {
  pname = "suricata";
  version = "7.0.7";

  src = fetchurl {
    url = "https://www.openinfosecfoundation.org/download/${pname}-${version}.tar.gz";
    hash = "sha256-JtCjYZTVMID8iwm5mbK1qDxASfQK0H72rmnHIlpyi4Y=";
  };

  nativeBuildInputs =
    [
      clang
      llvm
      makeWrapper
      pkg-config
    ]
    ++ lib.optionals rustSupport [
      rustc
      cargo
    ];

  propagatedBuildInputs = with python.pkgs; [
    pyyaml
  ];

  buildInputs =
    [
      elfutils
      jansson
      libbpf
      libcap_ng
      libevent
      libmagic
      libmaxminddb
      libnet
      libnetfilter_log
      libnetfilter_queue
      libnfnetlink
      libpcap
      libyaml
      luajit
      lz4
      nspr
      pcre2
      python
      zlib
    ]
    ++ lib.optional hyperscanSupport hyperscan
    ++ lib.optionals redisSupport [
      redis
      hiredis
    ];

  enableParallelBuilding = true;

  patches = lib.optional stdenv.is64bit ./bpf_stubs_workaround.patch;

  postPatch = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/file" "${file}/bin/file"
    substituteInPlace ./libhtp/configure \
      --replace "/usr/bin/file" "${file}/bin/file"

    mkdir -p bpf_stubs_workaround/gnu
    touch bpf_stubs_workaround/gnu/stubs-32.h
  '';

  configureFlags =
    [
      "--disable-gccmarch-native"
      "--enable-af-packet"
      "--enable-ebpf"
      "--enable-ebpf-build"
      "--enable-gccprotect"
      "--enable-geoip"
      "--enable-luajit"
      "--enable-nflog"
      "--enable-nfqueue"
      "--enable-pie"
      "--enable-python"
      "--enable-unix-socket"
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-libnet-includes=${libnet}/include"
      "--with-libnet-libraries=${libnet}/lib"
    ]
    ++ lib.optionals hyperscanSupport [
      "--with-libhs-includes=${hyperscan.dev}/include/hs"
      "--with-libhs-libraries=${hyperscan}/lib"
    ]
    ++ lib.optional redisSupport "--enable-hiredis"
    ++ lib.optionals rustSupport [
      "--enable-rust"
      "--enable-rust-experimental"
    ];

  postConfigure = ''
    # Avoid unintended clousure growth.
    sed -i 's|${builtins.storeDir}/\(.\{8\}\)[^-]*-|${builtins.storeDir}/\1...-|g' ./src/build-info.h
  '';

  hardeningDisable = [ "stackprotector" ];

  installFlags = [
    "e_datadir=\${TMPDIR}"
    "e_localstatedir=\${TMPDIR}"
    "e_logdir=\${TMPDIR}"
    "e_logcertsdir=\${TMPDIR}"
    "e_logfilesdir=\${TMPDIR}"
    "e_rundir=\${TMPDIR}"
    "e_sysconfdir=\${out}/etc/suricata"
    "e_sysconfrulesdir=\${out}/etc/suricata/rules"
    "localstatedir=\${TMPDIR}"
    "runstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
  ];

  installTargets = [
    "install"
    "install-conf"
  ];

  postInstall = ''
    wrapProgram "$out/bin/suricatasc" \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out")
    substituteInPlace "$out/etc/suricata/suricata.yaml" \
      --replace "/etc/suricata" "$out/etc/suricata"
  '';

  meta = with lib; {
    description = "A free and open source, mature, fast and robust network threat detection engine";
    homepage = "https://suricata.io";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magenbluten ];
  };
}
