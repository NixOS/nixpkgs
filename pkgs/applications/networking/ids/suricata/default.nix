# TODO:
# - CUDA support (note: requires driver API, not the runtime API, so cudatoolkit doesn't work)

{ stdenv
, lib
, fetchurl
, pkgconfig
, makeWrapper
, file
, geoip
, hyperscan
, jansson
, libcap_ng
, libevent
, libnet
, libnetfilter_log
, libnetfilter_queue
, libnfnetlink
, libpcap
, libprelude
, libyaml
, luajit
, nspr
, nss
, pcre
, python
, zlib
, redisSupport ? false, redis, hiredis
, rustSupport ? false, rustc, cargo
}:

let

  libmagic = file;
  hyperscanSupport = stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";

in
stdenv.mkDerivation rec {
  version = "4.0.3";
  name = "suricata-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://www.openinfosecfoundation.org/download/${name}.tar.gz";
    sha256 = "0dz4w3dz65bzhq6k1iha0rmy7w0bywzaqjpvxbph02sw1fqvr841";
  };

  nativeBuildInputs = [
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    geoip
    jansson
    libcap_ng
    libevent
    libmagic
    libnet
    libnetfilter_log
    libnetfilter_queue
    libnfnetlink
    libpcap
    libprelude
    libyaml
    luajit
    nspr
    nss
    pcre
    python
    zlib
  ]
  ++ lib.optional hyperscanSupport [ hyperscan ]
  ++ lib.optional redisSupport [ redis hiredis ]
  ++ lib.optional rustSupport [ rustc cargo ]
  ;

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-gccmarch-native"
    "--enable-afl"
    "--enable-af-packet"
    "--enable-gccprotect"
    "--enable-geoip"
    "--enable-luajit"
    "--enable-nflog"
    "--enable-nfqueue"
    "--enable-pie"
    "--enable-prelude"
    "--enable-python"
    "--enable-unix-socket"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-libnet-includes=${libnet}/include"
    "--with-libnet-libraries=${libnet}/lib"
  ]
  ++ lib.optional hyperscanSupport [
    "--with-libhs-includes=${hyperscan}/include"
    "--with-libhs-libraries=${hyperscan}/lib"
  ]
  ++ lib.optional redisSupport [ "--enable-hiredis" ]
  ++ lib.optional rustSupport [
    "--enable-rust"
    "--enable-rust-experimental"
  ]
  ;

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

  installTargets = "install install-conf";

  postInstall = ''
    wrapProgram "$out/bin/suricatasc" \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out")
  '';

  meta = with stdenv.lib; {
    description = "A free and open source, mature, fast and robust network threat detection engine";
    homepage = https://suricata-ids.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
