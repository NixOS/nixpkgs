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
  version = "23.06.06-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "openpbs";
    repo = "openpbs";
    rev = "e395fe79388d5f77908eeb80e3bb73d848315449";
    hash = "sha256-FQgps7vdxz4gIAEE333MvELWf+Qx7dhnpoH4hLwOp5Q=";
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

  # https://github.com/openpbs/openpbs/issues/2713
  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;

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
