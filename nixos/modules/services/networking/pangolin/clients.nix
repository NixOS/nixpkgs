# This module manages both Newt and Olm.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStrings
    genAttrs
    getExe
    head
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    stringToCharacters
    tail
    toUpper
    ;
  inherit (lib.types)
    bool
    float
    int
    listOf
    nullOr
    oneOf
    path
    str
    submodule
    ;
  inherit (lib.cli) toGNUCommandLineShell;
  cfg = config.services;

  mkClientModules = genAttrs [
    "newt"
    "olm"
  ];

  prettyName =
    pkg:
    let
      chars = stringToCharacters pkg;
    in
    concatStrings ([ (toUpper (head chars)) ] ++ (tail chars));

  packageDescription =
    pkg:
    "${prettyName pkg}, tunneling client for ${if pkg == "newt" then "Pangolin" else "Newt sites"}";
in
{
  options.services = mkClientModules (pkg: {
    enable = mkEnableOption (packageDescription pkg);
    package = mkPackageOption pkgs "fosrl-${pkg}" { };

    settings = mkOption {
      type = submodule {
        freeformType =
          let
            valueType =
              nullOr (oneOf [
                bool
                int
                float
                str
                path
                (listOf valueType)
              ])
              // {
                description = "value coercible to CLI argument";
              };
          in
          valueType;
        # Add Newt/Olm options you need the value of here.
        options =
          if (pkg == "newt") then
            # Newt-specific options:
            { native = mkEnableOption "the native WireGuard interface when accepting clients"; }
          else
            # Olm-specific options:
            { };
      };
      default = { };
      example = {
        endpoint = "https://pangolin.example.test";
        log-level = "DEBUG";
        ${if (pkg == "newt") then "accept-clients" else "holepunch"} = true;
        mtu = 1300;
      };
      description = ''
        The command line options passed to ${prettyName pkg}.
      '';
    };
    # Provide a path to file to keep secrets out of the Nix Store.
    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Path to a file containing sensitive environment variables for ${prettyName pkg}.
        These will overwrite anything defined in the config.

        The file should contain environment variable assignments similar to the following:

        ```
        ${toUpper pkg}_ID=2ix2t8xk22ubpfy
        ${toUpper pkg}_SECRET=nnisrfsdfc7prqsp9ewo1dvtvci50j5uiqotez00dgap0ii2
        ```
      '';
    };
  });

  config = mkIf (cfg.newt.enable || cfg.olm.enable) {
    assertions =
      (map
        (pkg: {
          assertion = cfg.${pkg}.enable -> cfg.${pkg}.environmentFile != null;
          message = "services.${pkg}.environmentFile must be provided when ${prettyName pkg} is enabled. The environment file must include the ${toUpper pkg}_SECRET variable.";
        })
        [
          "newt"
          "olm"
        ]
      )
      ++ [
        {
          assertion = cfg.newt.enable -> !cfg.olm.enable;
          message = "You cannot run Newt and Olm simultaneously on the same machine.";
        }
      ];

    systemd.services = mkClientModules (
      pkg:
      mkIf cfg.${pkg}.enable {
        description = packageDescription pkg;
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.HOME = "/var/lib/private/${pkg}";
        script = "exec ${getExe cfg.${pkg}.package} ${toGNUCommandLineShell { } cfg.${pkg}.settings}";

        serviceConfig = {
          # Native mode requires root permissions.
          DynamicUser = if (pkg == "olm") then true else !cfg.newt.settings.native;

          StateDirectory = pkg;
          StateDirectoryMode = "0700";
          Restart = "always";
          RestartSec = "10s";
          EnvironmentFile = cfg.${pkg}.environmentFile;

          # Service hardening.
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = "disconnected";
          PrivateDevices = true;
          PrivateUsers = true;
          PrivateMounts = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          LockPersonality = true;
          RestrictRealtime = true;
          ProtectClock = true;
          ProtectProc = "noaccess";
          ProtectHostname = true;
          RemoveIPC = true;
          NoNewPrivileges = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          CapabilityBoundingSet = [
            "~CAP_BLOCK_SUSPEND"
            "~CAP_BPF"
            "~CAP_CHOWN"
            "~CAP_MKNOD"
            "~CAP_NET_RAW"
            "~CAP_PERFMON"
            "~CAP_SYS_BOOT"
            "~CAP_SYS_CHROOT"
            "~CAP_SYS_MODULE"
            "~CAP_SYS_NICE"
            "~CAP_SYS_PACCT"
            "~CAP_SYS_PTRACE"
            "~CAP_SYS_TIME"
            "~CAP_SYS_TTY_CONFIG"
            "~CAP_SYSLOG"
            "~CAP_WAKE_ALARM"
          ];
          SystemCallFilter = [
            "~@aio:EPERM"
            "~@chown:EPERM"
            "~@clock:EPERM"
            "~@cpu-emulation:EPERM"
            "~@debug:EPERM"
            "~@keyring:EPERM"
            "~@memlock:EPERM"
            "~@module:EPERM"
            "~@mount:EPERM"
            "~@obsolete:EPERM"
            "~@pkey:EPERM"
            "~@privileged:EPERM"
            "~@raw-io:EPERM"
            "~@reboot:EPERM"
            "~@resources:EPERM"
            "~@sandbox:EPERM"
            "~@setuid:EPERM"
            "~@swap:EPERM"
            "~@sync:EPERM"
            "~@timer:EPERM"
          ];
        };
      }
    );
  };
  meta.maintainers = with maintainers; [
    jackr
    sigmasquadron
  ];
}
