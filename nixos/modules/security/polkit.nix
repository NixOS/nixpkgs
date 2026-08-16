{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    mkRemovedOptionModule
    types
    ;

  cfg = config.security.polkit;

  iniFmt = pkgs.formats.ini { };
in

{
  imports = [
    (mkRemovedOptionModule [ "security" "polkit" "debug" ] "Use security.polkit.extraArgs instead")
  ];

  options.security.polkit = {
    enable = mkEnableOption "polkit";

    enablePkexecWrapper = mkEnableOption "the setuid pkexec wrapper";

    package = mkPackageOption pkgs "polkit" { };

    settings = mkOption {
      description = ''
        Options for polkitd.
        See {manpage}`polkitd.conf(5)` for available options.
      '';
      type = types.submodule {
        freeformType = iniFmt.type;
        options.Polkitd.ExpirationSeconds = lib.mkOption {
          description = "Expiration timeout of authenticated sesssions.";
          type = types.ints.positive;
          default = 300; # current polkit upstream default
        };
      };
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [
        "--no-debug"
        "--log-level=notice"
      ];
      description = ''
        List of arguments to pass to the polkitd executable.

        ::: {.note}
        To see debug logs you need to negate the default `--no-debug` setting.
        :::
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        /* Log authorization checks. */
        polkit.addRule(function(action, subject) {
          // Make sure to negate --no-debug in services.polkit.extraArgs: { security.polkit.extraArgs = [ "--log-level=notice" ]; }
          polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
        });

        /* Allow any local user to do anything (dangerous!). */
        polkit.addRule(function(action, subject) {
          if (subject.local) return "yes";
        });
      '';
      description = ''
        Any polkit rules to be added to config (in JavaScript ;-). See:
        <https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html#polkit-rules>
      '';
    };

    adminIdentities = mkOption {
      type = with types; listOf str;
      default = [ "unix-group:wheel" ];
      example = [
        "unix-user:alice"
        "unix-group:admin"
      ];
      description = ''
        Specifies which users are considered “administrators”, for those
        actions that require the user to authenticate as an
        administrator (i.e. have an `auth_admin`
        value).  By default, this is all users in the `wheel` group.
      '';
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      cfg.package.bin
      cfg.package.out
    ];

    services.dbus.packages = [ cfg.package.out ];

    systemd.packages = [ cfg.package.out ];

    systemd.services.polkit = {
      restartTriggers = [ config.system.path ];
      reloadTriggers = [
        config.environment.etc."polkit-1/rules.d/10-nixos.rules".source
      ];
      serviceConfig.ExecStart = [
        # nuke default ExecStart
        ""
        # provide our own instead
        (toString (
          [
            "${lib.getLib cfg.package}/lib/polkit-1/polkitd"
          ]
          ++ cfg.extraArgs
        ))
      ];
    };

    systemd.sockets."polkit-agent-helper".wantedBy = [ "sockets.target" ];

    systemd.services."polkit-agent-helper@".serviceConfig = lib.mkMerge [
      # The upstream unit inherits stderr to the polkit agent, which causes
      # agent processes to misinterpret diagnostic output from PAM modules
      # as protocol errors, resulting in tight re-execution loops.
      { StandardError = "journal"; }

      # The upstream unit uses PrivateDevices=yes and ProtectHome=yes,
      # which prevents PAM modules from accessing hardware (e.g. FIDO
      # tokens via /dev/hidraw*) or reading key files from home directories.
      (mkIf config.security.pam.u2f.enable {
        # Override upstream PrivateDevices=yes to allow access to /dev/hidraw*
        PrivateDevices = false;
        DeviceAllow = [
          "/dev/urandom r"
          "char-hidraw rw"
        ];
        # Override upstream ProtectHome=yes so pam_u2f can read
        # ~/.config/Yubico/u2f_keys (the default key file location)
        ProtectHome = "read-only";
      })
      (mkIf config.security.pam.zfs.enable {
        PrivateDevices = false;
        DeviceAllow = [
          "/dev/zfs rw"
        ];
      })
    ];

    # The polkit daemon reads action/rule files
    environment.pathsToLink = [ "/share/polkit-1" ];

    # PolKit rules for NixOS.
    environment.etc."polkit-1/rules.d/10-nixos.rules".text = ''
      polkit.addAdminRule(function(action, subject) {
        return [${lib.concatStringsSep ", " (map (i: "\"${i}\"") cfg.adminIdentities)}];
      });

      ${cfg.extraConfig}
    ''; # TODO: validation on compilation (at least against typos)

    environment.etc."polkit-1/polkitd.conf".source = iniFmt.generate "polkitd.conf" cfg.settings;
    security.pam.services.polkit-1 = { };

    security.wrappers.pkexec = {
      enable = cfg.enablePkexecWrapper;
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe' cfg.package "pkexec";
    };

    users.users.polkituser = {
      description = "PolKit daemon";
      uid = config.ids.uids.polkituser;
      group = "polkituser";
    };

    users.groups.polkituser = { };
  };

  meta = {
    maintainers = with lib.maintainers; [ zimward ];
  };
}
