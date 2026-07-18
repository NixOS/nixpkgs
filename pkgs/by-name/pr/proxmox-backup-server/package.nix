{
  lib,
  buildFHSEnv,
  stdenvNoCC,
  iproute2,
  proxmox-backup-server-unwrapped,
  nixosTests,
}:

# Runnable PBS: each binary from the unwrapped proxmox-backup-server-unwrapped
# package is wrapped in a buildFHSEnv. buildFHSEnv maps the base package's
# $out/{bin,lib,share} onto /usr, giving PBS the Debian FHS paths it hardcodes
# (web assets at /usr/share/javascript/proxmox-backup, helpers at
# /usr/lib/<multiarch>/proxmox-backup, /usr/bin/ip from iproute2). /run and /var
# are bind-mounted from the host automatically; /etc is a private tmpfs that
# already symlinks the host's passwd/group/shadow/ssl. Some target packages
# provide /etc/pam.d entries, which would otherwise shadow the host PAM stack,
# so we bind the host PAM directory back over it. We also bind the writable PBS
# config dir /etc/proxmox-backup. buildFHSEnv auto-binds every top-level host
# directory that exists when the daemons start, so datastores on those paths
# work as-is; see fhsExtraBwrapArgs below for what's added on top of that.

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proxmox-backup-server";
  inherit (proxmox-backup-server-unwrapped) version;

  fhsLibDir = "/usr/lib/${
    lib.replaceStrings [ "-unknown-" ] [ "-" ] stdenvNoCC.hostPlatform.config
  }/proxmox-backup";

  fhsTargetPkgs = [
    proxmox-backup-server-unwrapped
    iproute2
  ];
  fhsExtraBwrapArgs = [
    "--ro-bind-try /etc/pam.d /etc/pam.d"
    "--ro-bind-try /etc/ssh /etc/ssh"
    "--bind-try /etc/proxmox-backup /etc/proxmox-backup"
  ];

  # User-facing CLIs (on $PATH).
  cliLaunchers =
    lib.genAttrs
      [
        "pmt"
        "pmtx"
        "proxmox-tape"
        "pbs3to4"
        "proxmox-backup-debug"
        "proxmox-backup-manager"
      ]
      (
        n:
        buildFHSEnv {
          name = n;
          targetPkgs = _: finalAttrs.fhsTargetPkgs;
          runScript = "/usr/bin/${n}";
          extraBwrapArgs = finalAttrs.fhsExtraBwrapArgs;
        }
      );

  # Daemons the systemd units launch.
  daemonLaunchers =
    lib.genAttrs
      [
        "proxmox-backup-api"
        "proxmox-backup-proxy"
        "proxmox-daily-update"
      ]
      (
        n:
        buildFHSEnv {
          name = n;
          targetPkgs = _: finalAttrs.fhsTargetPkgs;
          runScript = "${finalAttrs.fhsLibDir}/${n}";
          extraBwrapArgs = finalAttrs.fhsExtraBwrapArgs;
        }
      );

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;
  passAsFile = [ "buildCommand" ];

  buildCommand = ''
    mkdir -p $out/bin $out/libexec/proxmox-backup

    ${lib.concatStrings (
      lib.mapAttrsToList (n: w: ''
        ln -s ${lib.getExe' w n} $out/bin/${n}
      '') finalAttrs.cliLaunchers
    )}

    ${lib.concatStrings (
      lib.mapAttrsToList (n: w: ''
        ln -s ${lib.getExe' w n} $out/libexec/proxmox-backup/${n}
      '') finalAttrs.daemonLaunchers
    )}

    # Shell completions and other share data from the base package.
    ln -s ${proxmox-backup-server-unwrapped}/share $out/share
  '';

  meta = proxmox-backup-server-unwrapped.meta // {
    description = "Proxmox Backup Server, wrapped to run its Debian-FHS-hardcoded binaries";
    longDescription = ''
      Runnable PBS: each binary from proxmox-backup-server-unwrapped wrapped in a
      buildFHSEnv so the Debian FHS paths PBS hardcodes at runtime resolve
      correctly. This is the package the NixOS module uses by default.
    '';
    mainProgram = "proxmox-backup-manager";
    maintainers = with lib.maintainers; [ awildleon ];
  };

  passthru = {
    base = proxmox-backup-server-unwrapped;
    tests.proxmox-backup-server = nixosTests.proxmox-backup-server;
  };
})
