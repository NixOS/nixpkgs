{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.moonshine;
  tomlFormat = pkgs.formats.toml { };
  configFile = tomlFormat.generate "moonshine-config.toml" cfg.settings;

  runScript = pkgs.writeShellScriptBin "moonshine-server" ''
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(${lib.getExe' pkgs.coreutils "id"} -u)}"
    export DBUS_SESSION_BUS_ADDRESS="''${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
    exec ${lib.getExe cfg.package} ${configFile} "$@"
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
        User under which to run Moonshine. The user must be declared separately
        in {option}`users.users`. Lingering is enabled automatically so the
        server can run without an active login session.
      '';
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          name = "my-desktop";
          address = "0.0.0.0";
          application = [
            {
              title = "Steam";
              command = [ "steam" "steam://open/bigpicture" ];
            }
          ];
          application_scanner = [
            {
              type = "steam";
              library = "$HOME/.local/share/Steam";
              command = [ "steam" "-bigpicture" "steam://rungameid/{game_id}" ];
            }
          ];
        }
      '';
      description = ''
        Moonshine configuration, generated as a TOML file in the Nix store.
        See <https://github.com/hgaiser/moonshine/blob/main/moonshine-core/src/config.rs>
        for the available settings and <https://github.com/hgaiser/moonshine#configuration> for some examples.

        Do not leave this option empty: Moonshine's upstream defaults configure
        Steam at {file}`/usr/bin/steam`, which does not exist on NixOS. Define
        at least `application` with an executable in the Nix store, as shown in
        the example. Setting `application` explicitly is sufficient;
        `application_scanners` may be omitted.

        Moonshine stores {file}`cert.pem` and {file}`key.pem` in
        {file}`~/.config/moonshine/`, and paired-client state in
        {file}`~/.local/share/moonshine/state.toml` for the configured user.

        Since the service runs without a desktop session, its notification
        action cannot reliably open the pairing page. Pair clients by visiting
        {file}`http://<host>:47989/pin` in a browser instead.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.steam ]";
      description = ''
        Packages added to the service's {env}`PATH` for applications launched
        by Moonshine.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        MESA_VK_DEVICE_SELECT = "10de:25a2!";
      };
      description = ''
        Environment variables set for Moonshine.

        ::: {.note}
        Those are not inherited by launched applications.
        :::
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
        Network interfaces on which to open the Moonlight/GameStream ports.
        The ports are not opened when this list is empty.
        Moonshine is not designed for use on public networks. Do not expose Moonshine ports directly to the internet. See https://github.com/hgaiser/moonshine#security
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasAttr cfg.user config.users.users;
        message = "services.moonshine.user refers to undeclared user '${cfg.user}'.";
      }
    ];

    boot.kernelModules = [
      "uinput"
      "uhid"
    ];

    environment.systemPackages = [ cfg.package ];

    # Make the implicit WSI Vulkan layer available to launched applications.
    hardware.graphics = {
      enable = true;
      extraPackages = [ cfg.package ];
    };

    networking.firewall.interfaces = lib.genAttrs cfg.firewallInterfaces (_: {
      allowedTCPPorts = [
        (cfg.settings.webserver.port_https or 47984)
        (cfg.settings.webserver.port or 47989)
        (cfg.settings.stream.port or 48010)
      ];
      allowedUDPPorts = [
        5353 # moonshine has an embedded mDNS responder that does not conflict with avahi
        (cfg.settings.stream.video.port or 47998)
        (cfg.settings.stream.control.port or 47999)
        (cfg.settings.stream.audio.port or 48000)
      ];
    });

    services.udev.packages = [ cfg.package ];

    systemd.services.moonshine = {
      description = "Streaming server using the NVIDIA GameStream / Moonlight protocol.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.xwayland ] ++ cfg.extraPackages;
      environment = {
        MOONSHINE_LOG = "moonshine=info";
      }
      // cfg.environment;
      serviceConfig = {
        User = cfg.user;
        SupplementaryGroups = [ "moonshine" ];
        ExecStart = lib.getExe runScript;
        Restart = "on-failure";
        RestartSec = 5;
        DeviceAllow = [
          "/dev/uinput rw"
          "/dev/uhid rw"
          "char-drm rw"
          "char-nvidia rw"
          "char-nvidia-uvm rw"
        ];
      };
    };

    users = {
      groups.moonshine = { };
      users.${cfg.user} = {
        linger = true;
        extraGroups = [ "input" ];
      };
    };
  };
}
