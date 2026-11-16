{
  lib,
  stdenv,
  fetchurl,
  gitUpdater,
  cmake,
  pkg-config,
  docutils,
  libnl,
  udev,
  udevCheckHook,
  python3,
  perl,
  withManPages ? !stdenv.hostPlatform.isi686,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdma-core";
  version = "65.0";

  # Use release tarball instead of git sources (contains pre-built man pages and avoids Pandoc dependency)
  src = fetchurl {
    url = "https://github.com/linux-rdma/rdma-core/releases/download/v${finalAttrs.version}/rdma-core-${finalAttrs.version}.tar.gz";
    hash = "sha256-jrk8FHQBRuBMKKwlh04Qa2HH06tmo20HCZ6TiYXvBoA=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
    "scripts"
  ]
  ++ lib.optionals withManPages [
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    udevCheckHook
  ]
  ++ lib.optionals withManPages [
    docutils
  ];

  buildInputs = [
    libnl
    perl
    udev
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_RUNDIR=/run"
    "-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib"
    "-DSYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
    (lib.cmakeFeature "Python_EXECUTABLE" python3.pythonOnBuildForHost.interpreter)
  ]
  ++ lib.optionals (!withManPages) [
    "-DNO_MAN_PAGES=1"
  ];

  postPatch = ''
    substituteInPlace srp_daemon/srp_daemon.sh.in \
      --replace /bin/rm rm
  '';

  postInstall = ''
    # cmake script is buggy, move file manually
    mkdir -p $scripts/${perl.libPrefix}
    mv $out/share/perl5/* $scripts/${perl.libPrefix}
  '';

  postFixup = ''
    for pls in ibfindnodesusing.pl ibidsverify.pl check_lft_balance.pl; do
      echo "wrapping $pls"
      substituteInPlace $out/bin/$pls \
        --replace-fail "${perl}/bin/perl" "${perl}/bin/perl -I $scripts/${perl.libPrefix}"
      moveToOutput bin/$pls "$scripts"
    done
  '';

  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    url = "https://github.com/linux-rdma/rdma-core.git";
    rev-prefix = "v";
  };

  outputChecks.out.disallowedRequisites = [
    perl
  ];

  meta = {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
