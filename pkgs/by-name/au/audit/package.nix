{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bash,
  buildPackages,
  linuxHeaders,
  python3,
  swig,
  pkgsCross,
  libcap_ng,

  # Enabling python support while cross compiling would be possible, but the
  # configure script tries executing python to gather info instead of relying on
  # python3-config exclusively
  enablePython ? stdenv.hostPlatform == stdenv.buildPlatform,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audit";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "linux-audit";
    repo = "audit-userspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MWlHaGue7Ca8ks34KNg74n4Rfj8ivqAhLOJHeyE2Q04=";
  };

  patches = [
    # https://github.com/linux-audit/audit-userspace/pull/476
    ./musl.patch
  ];

  postPatch = ''
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace-fail "/usr/include/linux/audit.h" \
                     "${linuxHeaders}/include/linux/audit.h"
  '';

  # https://github.com/linux-audit/audit-userspace/issues/474
  # building databuf_test fails otherwise, as that uses hidden symbols only available in the static builds
  dontDisableStatic = true;

  outputs = [
    "bin"
    "lib"
    "dev"
    "out"
    "man"
  ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals enablePython [
    python3
    swig
  ];

  buildInputs = [
    bash
    libcap_ng
  ];

  configureFlags = [
    # z/OS plugin is not useful on Linux, and pulls in an extra openldap
    # dependency otherwise
    "--disable-zos-remote"
    "--with-arm"
    "--with-aarch64"
    # capability dropping, currently mostly for plugins as those get spawned as root
    # see auditd-plugins(5)
    "--with-libcap-ng=yes"
    (if enablePython then "--with-python" else "--without-python")
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      musl = pkgsCross.musl64.audit;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://people.redhat.com/sgrubb/audit/";
    description = "Audit Library";
    changelog = "https://github.com/linux-audit/audit-userspace/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ grimmauld ];
    pkgConfigModules = [
      "audit"
      "auparse"
    ];
    platforms = lib.platforms.linux;
  };
})
