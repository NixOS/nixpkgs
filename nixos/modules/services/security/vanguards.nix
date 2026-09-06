{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vanguards;
  torCfg = config.services.tor;

  # Tor's own runtime directory. Not user-configurable in nixos/modules/services/security/tor.nix
  # either (it is a `let runDir = "/run/tor";` at the top of that file), so hardcoding it here
  # matches upstream rather than inventing a knob Tor's own module doesn't expose.
  torRunDir = "/run/tor";

  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "vanguards.conf" cfg.settings;
in
{
  options.services.vanguards = {
    enable = lib.mkEnableOption ''
      Vanguards, the Tor Project's guard-discovery defense for long-lived onion services.
      Attaches to a running Tor instance's control port; does not run its own Tor'';

    package = lib.mkPackageOption pkgs "vanguards" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Settings written verbatim to vanguards.conf, an INI file with sections
        `Global`, `Vanguards`, `Bandguards`, `Rendguard` and `Logguard`. See
        <https://github.com/mikeperry-tor/vanguards/blob/master/vanguards-example.conf>
        for the full list of keys and their defaults - nothing here needs to
        be set unless you want to change vanguards' own defaults.
      '';
      example = lib.literalExpression ''
        {
          Global.enable_bandguards = false;
          Vanguards.num_layer3_guards = 4;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = torCfg.enable && torCfg.controlSocket.enable;
        message = ''
          services.vanguards requires services.tor.enable and
          services.tor.controlSocket.enable: vanguards attaches to Tor's
          existing control port, it does not start a Tor of its own.
        '';
      }
    ];

    # vanguards discovers Tor's authentication cookie through the control
    # protocol itself (Tor's PROTOCOLINFO command reports the path), so it
    # never needs to be told the path or given a copy of the value - only
    # filesystem access to wherever Tor puts it.
    #
    # CookieAuthentication is the only setting this actually requires; it
    # is off by default and there is no other secret-free way to authenticate.
    services.tor.settings.CookieAuthentication = lib.mkDefault true;

    systemd.services.vanguards = {
      description = "Vanguards guard-discovery defense for Tor";
      documentation = [ "https://github.com/mikeperry-tor/vanguards" ];

      # bindsTo, not just wants/requires: vanguards' state (which guards it
      # picked, when it rotated them) is meaningless once the Tor instance
      # it was protecting is gone, so it should stop when tor.service does
      # rather than keep running against a dead control port.
      after = [ "tor.service" ];
      bindsTo = [ "tor.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs [
          (lib.getExe cfg.package)
          "--control_socket"
          "${torRunDir}/control"
          "--config"
          configFile
          "--state"
          "/var/lib/vanguards/vanguards.state"
        ];

        # Not DynamicUser: vanguards reads more of Tor's state than just the
        # control socket and cookie. It reads the cached consensus directly
        # off disk (/var/lib/tor/cached-microdesc-consensus) to compute guard
        # weights, which the VM test caught the hard way - group membership
        # via SupplementaryGroups authenticates fine (the control socket and
        # cookie are both reachable that way) but then fails on that file
        # with EACCES, because Tor's StateDirectoryMode is 0700: owner-only,
        # no group bit at all. Sharing the tor user directly is what
        # upstream itself assumes ("vanguards discovers CookieAuthentication
        # automatically" reads as a companion process, not a sandboxed one),
        # and it is simpler than trying to open a second, narrower hole into
        # a state directory that is 0700 by design.
        User = "tor";
        Group = "tor";
        StateDirectory = "vanguards";
        StateDirectoryMode = "0700";

        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening. Runs as the tor user by necessity (see above), but gets
        # no privileges beyond that: no new privileges, no network access of
        # its own (it talks to Tor's control port, never the network
        # directly), and the same namespace/syscall restrictions any
        # unprivileged daemon in this file tree would get.
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        UMask = "0077";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };
}
