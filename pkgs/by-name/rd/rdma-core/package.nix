{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  pkg-config,
  docutils,
  pandoc,
  libnl,
  udev,
  udevCheckHook,
  python3,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdma-core";
  version = "64.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y0pCGkvCjZ1F9Ojouesozn2Lxj+x7/0ck6/9tJmdkWw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "man"
    "dev"
    "scripts"
  ];

  nativeBuildInputs = [
    cmake
    docutils
    pandoc
    pkg-config
    python3
    udevCheckHook
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
