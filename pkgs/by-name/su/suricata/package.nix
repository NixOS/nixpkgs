{
  stdenv,
  lib,
  fetchurl,
  clang,
  llvm,
  pkg-config,
  elfutils,
  file,
  jansson,
  libbpf_0,
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
  python3,
  vectorscan,
  zlib,
  redisSupport ? true,
  valkey,
  hiredis,
  rustSupport ? true,
  rustc,
  cargo,
  nixosTests,
}:
let
  libmagic = file;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "suricata";
  version = "8.0.3";

  src = fetchurl {
    url = "https://www.openinfosecfoundation.org/download/suricata-${finalAttrs.version}.tar.gz";
    hash = "sha256-PZp7gDuXwR4GDzNJsXm+qv1vlrjIqVCF2f3AjIIoF9k=";
  };

  patches = lib.optionals stdenv.hostPlatform.is64bit [
    # Provide empty gnu/stubs-32.h for eBPF build
    ./bpf_stubs_workaround.patch
  ];

  nativeBuildInputs = [
    clang
    llvm
    pkg-config
  ]
  ++ lib.optionals rustSupport [
    rustc
    cargo
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
  ];

  buildInputs = [
    elfutils
    jansson
    libbpf_0
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
    python3
    vectorscan
    zlib
  ]
  ++ lib.optionals redisSupport [
    valkey
    hiredis
  ];

  enableParallelBuilding = true;

  postPatch = ''
    mkdir -p bpf_stubs_workaround/gnu
    touch bpf_stubs_workaround/gnu/stubs-32.h
  '';

  configureFlags = [
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
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-libhs-includes=${lib.getDev vectorscan}/include/hs"
    "--with-libhs-libraries=${lib.getLib vectorscan}/lib"
    "--with-libnet-includes=${libnet}/include"
    "--with-libnet-libraries=${libnet}/lib"
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

  # zerocallusedregs interferes during BPF compilation; TODO: perhaps improve
  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  doCheck = true;

  installFlags = [
    "DESTDIR=\${out}"
    "prefix=/"
  ];

  installTargets = [
    "install"
    "install-conf"
  ];

  postInstall = ''
    substituteInPlace "$out/etc/suricata/suricata.yaml" \
      --replace-fail "/etc/suricata" "${placeholder "out"}/etc/suricata"
  '';

  passthru.tests = { inherit (nixosTests) suricata; };

  meta = {
    description = "Free and open source, mature, fast and robust network threat detection engine";
    homepage = "https://suricata.io";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
