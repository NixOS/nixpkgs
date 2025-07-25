{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "linux-audit";
    repo = "audit-userspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SgMt1MmcH7r7O6bmJCetRg3IdoZXAXjVJyeu0HRfyf8=";
  };

  patches = [
    # nix configures most stuff by symlinks, e.g. in /etc
    # thus, for plugins to be picked up, symlinks must be allowed
    # https://github.com/linux-audit/audit-userspace/pull/467
    (fetchpatch {
      url = "https://github.com/linux-audit/audit-userspace/pull/467/commits/dbefc642b3bd0cafe599fcd18c6c88cb672397ee.patch?full_index=1";
      hash = "sha256-Ksn/qKBQYFAjvs1OVuWhgWCdf4Bdp9/a+MrhyJAT+Bw=";
    })
    (fetchpatch {
      url = "https://github.com/linux-audit/audit-userspace/pull/467/commits/50094f56fefc0b9033ef65e8c4f108ed52ef5de5.patch?full_index=1";
      hash = "sha256-CJKDLdlpsCd+bG6j5agcnxY1+vMCImHwHGN6BXURa4c=";
    })
    (fetchpatch {
      url = "https://github.com/linux-audit/audit-userspace/pull/467/commits/5e75091abd297807b71b3cfe54345c2ef223939a.patch?full_index=1";
      hash = "sha256-LPpO4PH/3MyCJq2xhmhhcnFeK3yh7LK6Mjypuvhacu4=";
    })
  ];

  postPatch = ''
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace-fail "/usr/include/linux/audit.h" \
                     "${linuxHeaders}/include/linux/audit.h"
  '';

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
