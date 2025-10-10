{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  config,
  pkg-config,
  libtool,
  curl,
  python3,
  munge,
  perl,
  pam,
  shadow,
  coreutils,
  dbus,
  libbpf,
  ncurses,
  libmysqlclient,
  lua,
  hwloc,
  numactl,
  readline,
  freeipmi,
  xauth,
  lz4,
  rdma-core,
  nixosTests,
  pmix,
  libjwt,
  libyaml,
  json_c,
  http-parser,
  # enable internal X11 support via libssh2
  enableX11 ? true,
  enableNVML ? config.cudaSupport,
  nvml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slurm";
  version = "25.05.3.1";

  # N.B. We use github release tags instead of https://www.schedmd.com/downloads.php
  # because the latter does not keep older releases.
  src = fetchFromGitHub {
    owner = "SchedMD";
    repo = "slurm";
    # The release tags use - instead of .
    rev = "slurm-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-W/q9eN4Ov3pxp2qyr3b7G4ayDaNtFUPQeAcOHCB23Q8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  prePatch = ''
    substituteInPlace src/common/env.c \
        --replace "/bin/echo" "${lib.getExe' coreutils "echo"}"

    # Autoconf does not support split packages for pmix (libs and headers).
    # Fix the path to the pmix libraries, so dlopen can find it.
    substituteInPlace src/plugins/mpi/pmix/mpi_pmix.c \
        --replace 'xstrfmtcat(full_path, "%s/", PMIXP_LIBPATH)' \
                  'xstrfmtcat(full_path, "${lib.getLib pmix}/lib/")'

  ''
  + (lib.optionalString enableX11 ''
    substituteInPlace src/common/x11_util.c \
        --replace '"/usr/bin/xauth"' '"${lib.getExe xauth}"'
  '');

  # nixos test fails to start slurmd with 'undefined symbol: slurm_job_preempt_mode'
  # https://groups.google.com/forum/#!topic/slurm-devel/QHOajQ84_Es
  # this doesn't fix tests completely at least makes slurmd to launch
  hardeningDisable = [ "bindnow" ];

  nativeBuildInputs = [
    pkg-config
    libtool
    python3
    perl
  ];
  buildInputs = [
    curl
    python3
    munge
    pam
    libmysqlclient
    ncurses
    lz4
    rdma-core
    lua
    hwloc
    numactl
    readline
    freeipmi
    shadow.su
    pmix
    json_c
    libjwt
    libyaml
    dbus
    libbpf
    http-parser
  ]
  ++ lib.optionals enableX11 [ xauth ]
  ++ lib.optionals enableNVML [
    (runCommand "collect-nvml" { } ''
      mkdir $out
      ln -s ${lib.getDev nvml}/include $out/include
      ln -s ${lib.getLib nvml}/lib/stubs $out/lib
    '')
  ];

  configureFlags = [
    "--with-freeipmi=${freeipmi}"
    "--with-http-parser=${http-parser}"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-json=${lib.getDev json_c}"
    "--with-jwt=${libjwt}"
    "--with-lz4=${lib.getDev lz4}"
    "--with-munge=${munge}"
    "--with-yaml=${lib.getDev libyaml}"
    "--with-ofed=${lib.getDev rdma-core}"
    "--sysconfdir=/etc/slurm"
    "--with-pmix=${lib.getDev pmix}"
    "--with-bpf=${libbpf}"
    "--without-rpath" # Required for configure to pick up the right dlopen path
  ]
  ++ (lib.optional (!enableX11) "--disable-x11")
  ++ (lib.optional enableNVML "--with-nvml");

  preConfigure = ''
    patchShebangs ./doc/html/shtml2html.py
    patchShebangs ./doc/man/man2html.py
  '';

  postInstall = ''
    rm -f $out/lib/*.la $out/lib/slurm/*.la
  '';

  enableParallelBuilding = true;

  passthru.tests.slurm = nixosTests.slurm;

  meta = {
    homepage = "http://www.schedmd.com/";
    description = "Simple Linux Utility for Resource Management";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      jagajaga
      markuskowa
    ];
  };
})
