{ stdenv
, lib
, fetchurl
, clang
, llvm
, pkgconfig
, makeWrapper
, file
, hyperscan
, jansson
, libbpf
, libcap_ng
, libelf
, libevent
, libmaxminddb
, libnet
, libnetfilter_log
, libnetfilter_queue
, libnfnetlink
, libpcap
, libyaml
, luajit
, lz4
, nspr
, nss
, pcre
, python
, zlib
, redisSupport ? true, redis, hiredis
, rustSupport ? true, rustc, cargo
}: let
  libmagic = file;
  hyperscanSupport = stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";
in
stdenv.mkDerivation rec {
  pname = "suricata";
  version = "5.0.2";

  src = fetchurl {
    url = "https://www.openinfosecfoundation.org/download/${pname}-${version}.tar.gz";
    sha256 = "1ryfa3bzd8mrq2k5kjfwmblxqqziz6b9n1dnh692mazf5z4wlc3z";
  };

  nativeBuildInputs = [
    clang
    llvm
    makeWrapper
    pkgconfig
  ]
  ++ lib.optionals rustSupport [ rustc cargo ]
  ;

  buildInputs = [
    jansson
    libbpf
    libcap_ng
    libelf
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
    nss
    pcre
    python
    zlib
  ]
  ++ lib.optional hyperscanSupport hyperscan
  ++ lib.optionals redisSupport [ redis hiredis ]
  ;

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
    "--disable-prelude"
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
    sed -i 's|/nix/store/\(.\{8\}\)[^-]*-|/nix/store/\1...-|g' ./src/build-info.h
  '';

  hardeningDisable = [ "stackprotector" ];

  installFlags = [
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

  installTargets = [ "install" "install-conf" ];

  postInstall = ''
    wrapProgram "$out/bin/suricatasc" \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out")
    substituteInPlace "$out/etc/suricata/suricata.yaml" \
      --replace "/etc/suricata" "$out/etc/suricata"
  '';

  meta = with stdenv.lib; {
    description = "A free and open source, mature, fast and robust network threat detection engine";
    homepage = "https://suricata-ids.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magenbluten ];
  };
}
