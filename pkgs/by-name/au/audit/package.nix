{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bash,
  bashNonInteractive,
  buildPackages,
  linuxHeaders,
  python3Packages,
  swig,
  libcap_ng,
  installShellFiles,
  makeWrapper,
  gawk,
  gnugrep,
  coreutils,

  enablePython ?
    !stdenv.hostPlatform.isStatic
    && stdenv.hostPlatform.parsed.cpu.bits == stdenv.buildPlatform.parsed.cpu.bits,

  # passthru
  nix-update-script,
  testers,
  nixosTests,
  pkgsStatic ? { }, # CI has allowVariants = false, in which case pkgsMusl would not be passed. So, instead add a default here.
  pkgsMusl ? { },
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audit";
  version = "4.1.2"; # fixes to non-static builds right after 4.1.2 release

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
    "scripts"
  ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals enablePython [
    python3Packages.python # for python3-config
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
    (lib.withFeature enablePython "python3")
  ];

  __structuredAttrs = true;

  # lib output is part of the mandatory nixos system closure, so avoid bash here
  outputChecks.lib.disallowedRequisites = [
    bash
    bashNonInteractive
  ];

  # bin output is used if audit is enabled, becoming part of the system closure.
  outputChecks.bin.disallowedRequisites = [
    bash
    bashNonInteractive
  ];

  nativeCheckInputs = lib.optionals enablePython [
    python3Packages.pythonImportsCheckHook
  ];

  pythonImportsCheck = [ "audit" ];

  enableParallelChecking = false;
  doCheck = true;

  postInstall = ''
    installShellCompletion --bash init.d/audit.bash_completion
  '';

  # augenrules is a bit broken, but may be helpful to collect audit rules in a builder.
  # It is not required on a running system, it can just go into its own output.
  # audit-rules.service relies on augenrules, and is not useful on a nixos system.
  # It is intended to collect rule files from /etc/audit/rules.d, which we don't set up.
  # Instead, we load audit rules in a dedicated module.
  postFixup = ''
    moveToOutput bin/augenrules $scripts
    substituteInPlace $scripts/bin/augenrules \
      --replace-fail "/sbin/auditctl -R" "$bin/bin/auditctl -R" \
      --replace-fail "auditctl -s" "$bin/bin/auditctl -s" \
      --replace-fail "/bin/ls" "ls"
    wrapProgram $scripts/bin/augenrules \
      --prefix PATH : ${
        lib.makeBinPath [
          gawk
          gnugrep
          coreutils
        ]
      }

      rm $out/lib/systemd/system/audit-rules.service
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      musl = pkgsMusl.audit or null;
      static = pkgsStatic.audit or null;
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
