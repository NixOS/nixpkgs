{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.isponsorblocktv;
  systemd-run = lib.getExe' pkgs.systemd "systemd-run";
  isponsorblocktv-pkg = lib.getExe cfg.package;

  # The setup service needs to be run manually. See https://github.com/dmunozv04/iSponsorBlockTV#usage
  isponsorblocktv-setup = ''
    exec ${systemd-run} \
      --pty \
      --wait \
      --description="iSponsorBlockTV CLI configurator" \
      --property=DynamicUser=yes \
      --property=WorkingDirectory=/var/lib/isponsorblocktv \
      --property=StateDirectory=isponsorblocktv \
      --property=StateDirectoryMode=0700 \
      --property=ProtectSystem=strict \
      --property=ProtectHome=yes \
      --property=PrivateTmp=yes \
      --property=PrivateDevices=yes \
      --property=NoNewPrivileges=yes \
      --property=CapabilityBoundingSet= \
      --property=AmbientCapabilities= \
      --property=SystemCallFilter=@system-service \
      --property=SystemCallArchitectures=native \
      --property=ProtectKernelTunables=yes \
      --property=ProtectKernelModules=yes \
      --property=ProtectKernelLogs=yes \
      --property=ProtectClock=yes \
      --property=ProtectControlGroups=yes \
      --property=RestrictNamespaces=yes \
      --property=LockPersonality=yes \
      --property=MemoryDenyWriteExecute=yes \
      --property=RestrictRealtime=yes \
      --property=RestrictSUIDSGID=yes \
      --property=RemoveIPC=yes \
      --property=UMask=0066 \
      --property=RestrictAddressFamilies=AF_INET \
      --property=RestrictAddressFamilies=AF_INET6 \
      --property=Conflicts=isponsorblocktv.service \
      -- \
      ${isponsorblocktv-pkg} --setup --data /var/lib/isponsorblocktv
  '';
in
{
  options.services.isponsorblocktv = {
    enable = lib.mkEnableOption "isponsorblocktv";
    package = lib.mkPackageOption pkgs "isponsorblocktv" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      (pkgs.writeShellScriptBin "isponsorblocktv-setup" isponsorblocktv-setup)
    ];

    systemd.services.isponsorblocktv = {
      description = "iSponsorBlockTV - SponsorBlock client for YouTube TV";
      documentation = [ "https://github.com/dmunozv04/iSponsorBlockTV" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        ConditionPathExists = "/var/lib/isponsorblocktv/config.json";
        StartLimitIntervalSec = "120s";
      };

      serviceConfig = {
        ExecStart = "${isponsorblocktv-pkg} --data /var/lib/isponsorblocktv";
        WorkingDirectory = "/var/lib/isponsorblocktv";

        DynamicUser = true;
        StateDirectory = "isponsorblocktv"; # /var/lib/isponsorblocktv
        StateDirectoryMode = "0700";

        Restart = "always";
        RestartSec = "10s";
        StartLimitBurst = 5;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;

        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        AmbientCapabilities = "";

        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@swap"
          "~@obsolete"
        ];
        SystemCallArchitectures = "native";

        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        UMask = "0066";

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ gaelj ];
}
