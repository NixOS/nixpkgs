{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
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
  version = "63.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YW6BJS6acj9S8wFXUhC1vrJSm9YowGGuwWEBzQRVyPM=";
  };

  strictDeps = true;

  outputs = [
    "out"
    "man"
    "dev"
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

  patches = [
    (fetchurl {
      # remove when rdma-core 64.0 is released
      # https://github.com/linux-rdma/rdma-core/pull/1737
      name = "cmake-allow-overriding-sysusers.d-install-directory";
      url = "https://github.com/linux-rdma/rdma-core/commit/8b186b5d932701e94bbced83d2f3899ee53f041a.patch?full_index=1";
      hash = "sha256-Rjknu7mmJL2Sx+Ypq9SRXU4LUiHERs9j5/qMIZaiRTI=";
    })
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
    mkdir -p $out/${perl.libPrefix}
    mv $out/share/perl5/* $out/${perl.libPrefix}
  '';

  postFixup = ''
    for pls in $out/bin/{ibfindnodesusing.pl,ibidsverify.pl}; do
      echo "wrapping $pls"
      substituteInPlace $pls --replace \
        "${perl}/bin/perl" "${perl}/bin/perl -I $out/${perl.libPrefix}"
    done
  '';

  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
