{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.moonshine;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "moonshine-config.toml" cfg.settings;
  runtimeDir = "/run/user/${toString cfg.uid}";

  ports = {
    tcp = [
      (cfg.settings.webserver.port_https or 47984)
      (cfg.settings.webserver.port or 47989)
      (cfg.settings.stream.port or 48010)
    ];
    udp = [
      5353 # mDNS
      (cfg.settings.stream.video.port or 47998)
      (cfg.settings.stream.control.port or 47999)
      (cfg.settings.stream.audio.port or 48000)
    ];
  };

  # Only the manifest belongs in the graphics driver path. It refers to the
  # layer library in cfg.package by its absolute store path.
  wsiLayer = pkgs.runCommand "moonshine-wsi-layer" { } ''
    install -Dm644 \
      ${cfg.package}/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json \
      $out/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json
  '';
in
{
  options.services.moonshine = {
    enable = lib.mkEnableOption "Moonshine, a headless game streaming server for Moonlight clients";

    package = lib.mkPackageOption pkgs "moonshine" { };

    user = lib.mkOption {
      type = lib.types.nonEmptyStr;
      example = "alice";
      description = ''
        User under which to run Moonshine. The user must be declared in
        {option}`users.users`. Lingering is enabled automatically.
      '';
    };

    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = config.users.users.${cfg.user}.uid or null;
      defaultText = lib.literalExpression "config.users.users.<name>.uid";
      example = 1000;
      description = ''
        Numeric uid of {option}`services.moonshine.user`. This is used for the
        runtime directory and user systemd instance. Set it explicitly when
        the user's uid is not declared in the NixOS configuration.
      '';
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      example = lib.literalExpression ''
        {
          name = "my-desktop";
          application = [
            {
              title = "Steam";
              command = [ "/run/current-system/sw/bin/steam" "steam://open/bigpicture" ];
            }
          ];
        }
      '';
      description = ''
        Moonshine configuration, generated as a TOML file in the Nix store.
        See <https://github.com/hgaiser/moonshine#configuration> for available
        settings. Upstream's default application uses `/usr/bin/steam`, so an
        application with a NixOS executable path should normally be specified.
      '';
    };

    logFilter = lib.mkOption {
      type = lib.types.str;
      default = "moonshine=info";
      description = "Value of the `MOONSHINE_LOG` tracing filter.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the configured GameStream ports on all interfaces. Moonshine is
        not designed for public networks; expose it only on a LAN or VPN.
      '';
    };

    firewallInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "tailscale0"
        "wg0"
      ];
      description = ''
        Interfaces on which to open the configured GameStream ports. This is
        a narrower alternative to {option}`services.moonshine.openFirewall`.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.steam ]";
      description = "Packages added to the Moonshine service's executable search path.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example.MESA_VK_DEVICE_SELECT = "10de:25a2!";
      description = ''
        Environment variables for the Moonshine daemon. These are not
        inherited by applications launched through the user's systemd instance.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.users.users.${cfg.user}.isNormalUser || config.users.users.${cfg.user}.isSystemUser;
        message = "services.moonshine.user must refer to a declared normal or system user.";
      }
      {
        assertion = cfg.uid != null;
        message = ''
          services.moonshine.uid could not be derived because
          users.users.${cfg.user}.uid is not set. Set services.moonshine.uid
          explicitly or declare a fixed uid for the user.
        '';
      }
    ];

    boot.kernelModules = [
      "uinput"
      "uhid"
    ];

    environment.systemPackages = [ cfg.package ];

    hardware.graphics = {
      enable = true;
      extraPackages = [ wsiLayer ];
    };

    services.udev.packages = [ cfg.package ];

    networking.firewall = {
      allowedTCPPorts = lib.mkIf cfg.openFirewall ports.tcp;
      allowedUDPPorts = lib.mkIf cfg.openFirewall ports.udp;
      interfaces = lib.genAttrs cfg.firewallInterfaces (_: {
        allowedTCPPorts = ports.tcp;
        allowedUDPPorts = ports.udp;
      });
    };

    users = {
      groups.moonshine = { };
      users.${cfg.user} = {
        linger = true;
        extraGroups = [ "input" ];
      };
    };

    systemd.services.moonshine = {
      description = "Moonshine game streaming server";
      wantedBy = [ "multi-user.target" ];
      requires = [ "user@${toString cfg.uid}.service" ];
      after = [
        "network.target"
        "user@${toString cfg.uid}.service"
      ];
      path = [ pkgs.xwayland ] ++ cfg.extraPackages;
      environment = {
        MOONSHINE_LOG = cfg.logFilter;
        XDG_RUNTIME_DIR = runtimeDir;
        DBUS_SESSION_BUS_ADDRESS = "unix:path=${runtimeDir}/bus";
      }
      // cfg.environment;
      serviceConfig = {
        User = cfg.user;
        SupplementaryGroups = [
          "moonshine"
          "video"
        ];
        ExecStart = "${lib.getExe cfg.package} ${configFile}";
        Restart = "on-failure";
        RestartSec = 5;
        DeviceAllow = [
          "/dev/uinput rw"
          "/dev/uhid rw"
          "char-drm rw"
          "char-nvidia rw"
          "char-nvidia-uvm rw"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    neobrain
    anish
    philocalyst
  ];
}
