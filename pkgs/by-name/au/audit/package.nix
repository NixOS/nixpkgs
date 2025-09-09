{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bash,
  bashNonInteractive,
  buildPackages,
  linuxHeaders,
  python3,
  swig,
  pkgsCross,
  libcap_ng,
  installShellFiles,

  # Enabling python support while cross compiling would be possible, but the
  # configure script tries executing python to gather info instead of relying on
  # python3-config exclusively
  enablePython ? stdenv.hostPlatform == stdenv.buildPlatform,
  nix-update-script,
  testers,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audit";
  version = "4.1.2-unstable-2025-09-06"; # fixes to non-static builds right after 4.1.2 release

  src = fetchFromGitHub {
    owner = "linux-audit";
    repo = "audit-userspace";
    rev = "cb13fe75ee2c36d5c525ed9de22aae10dbc8caf4";
    hash = "sha256-NX0TWA+LtcZgbM9aQfokWv2rGNAAb3ksGqAH8URAkYM=";
  };

  postPatch = ''
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace-fail "/usr/include/linux/audit.h" \
                     "${linuxHeaders}/include/linux/audit.h"
  ''
  + lib.optionalString (enablePython && finalAttrs.finalPackage.doCheck) ''
    patchShebangs auparse/test/auparse_test.py
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
    installShellFiles
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
    # remove legacy start/stop scripts to remove a bash dependency in $lib
    # People interested in logging auditd interactions (e.g. for compliance) can start/stop audit using `auditctl --signal`
    # See also https://github.com/linux-audit/audit-userspace?tab=readme-ov-file#starting-and-stopping-the-daemon
    "--disable-legacy-actions"
    "--with-arm"
    "--with-aarch64"
    "--with-io_uring"
    # allows putting audit files in /run/audit, which removes the requirement
    # to wait for tmpfiles to set up the /var/run -> /run symlink
    "--runstatedir=/run"
    # capability dropping, currently mostly for plugins as those get spawned as root
    # see auditd-plugins(5)
    "--with-libcap-ng=yes"
    (if enablePython then "--with-python" else "--without-python")
  ];

  __structuredAttrs = true;

  # lib output is part of the mandatory nixos system closure, so avoid bash here
  outputChecks.lib.disallowedRequisites = [
    bash
    bashNonInteractive
  ];

  doCheck = true;

  postInstall = ''
    installShellCompletion --bash init.d/audit.bash_completion
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      musl = pkgsCross.musl64.audit;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      audit = nixosTests.audit;
    };
  };

  meta = {
    homepage = "https://people.redhat.com/sgrubb/audit/";
    description = "Audit Library";
    changelog = "https://github.com/linux-audit/audit-userspace/releases/tag/v4.1.2";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ grimmauld ];
    pkgConfigModules = [
      "audit"
      "auparse"
    ];
    platforms = lib.platforms.linux;
  };
})
