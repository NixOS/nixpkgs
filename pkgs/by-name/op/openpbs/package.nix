{
  stdenv,
  fetchFromGitHub,
  lib,
  autoconf,
  automake,
  libtool,
  gnum4,
  symlinkJoin,
  tcl-8_5,
  tk-8_5,
  swig,
  pkg-config,
  cjson,
  openssl,
  zlib,
  libxt,
  libx11,
  libpq,
  python3,
  expat,
  libedit,
  hwloc,
  libical,
  krb5,
  munge,
  findutils,
  gawk,
}:
let
  tclWithTk = symlinkJoin {
    name = "tcl-with-tk";
    paths = [
      tcl-8_5
      tk-8_5
      tk-8_5.dev
    ];
  };
in
stdenv.mkDerivation {
  pname = "openpbs";
  version = "23.06.06-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "openpbs";
    repo = "openpbs";
    rev = "cfd431b703e8cbe3bc99db6fbbcdd970625ef032";
    hash = "sha256-NZoSZmcl9a/6YWHO7qRNknB6ii0JBLo5bOpHDRKeuwI=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gnum4
    tclWithTk
    swig
    pkg-config
    cjson
  ];
  buildInputs = [
    openssl
    zlib
    libxt
    libx11
    libpq
    python3
    expat
    libedit
    hwloc
    libical
    krb5
    munge
  ];

  enableParallelBuilding = true;

  patches = [
    ./2709.patch
    ./2711.patch
  ];

  postPatch = ''
    substituteInPlace src/cmds/scripts/Makefile.am --replace-fail "/etc/profile.d" "$out/etc/profile.d"
    substituteInPlace m4/pbs_systemd_unitdir.m4 --replace-fail "/usr/lib/systemd/system" "$out/lib/systemd/system"
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--with-tcl=${tclWithTk}"
    "--with-swig=${swig}"
    "--sysconfdir=$out/etc"
  ];

  postInstall = ''
    cp src/scheduler/pbs_{dedicated,holidays,resource_group,sched_config} $out/etc/
  '';

  postFixup = ''
    substituteInPlace $out/libexec/pbs_habitat --replace-fail /bin/ls ls
    find $out/bin/ $out/sbin/ $out/libexec/ $out/lib/ -type f -exec file "{}" + |
      awk -F: '/ELF/ {print $1}' |
      xargs patchelf --add-needed libmunge.so --add-rpath ${munge}/lib
  '';

  meta = {
    description = "HPC workload manager and job scheduler for desktops, clusters, and clouds";
    homepage = "https://www.openpbs.org/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lisanna-dettwyler ];
    platforms = lib.platforms.unix;
  };
}
