{ pkgs, lib, config, ... }:

let
  cfg = config.services.thelounge;
  dataDir = "/var/lib/thelounge";
  configJsData = "module.exports = " + builtins.toJSON (
    { inherit (cfg) public port; } // cfg.extraConfig
  );
  pluginManifest = {
    dependencies = builtins.listToAttrs (builtins.map (pkg: { name = lib.getName pkg; value = lib.getVersion pkg; }) cfg.plugins);
  };
  plugins = pkgs.runCommand "thelounge-plugins" {
    preferLocalBuild = true;
  } ''
    mkdir -p $out/node_modules
    echo ${lib.escapeShellArg (builtins.toJSON pluginManifest)} >> $out/package.json
    ${lib.concatMapStringsSep "\n" (pkg: ''
    ln -s ${pkg}/lib/node_modules/${lib.getName pkg} $out/node_modules/${lib.getName pkg}
    '') cfg.plugins}
  '';
in
{
  imports = [ (lib.mkRemovedOptionModule [ "services" "thelounge" "private" ] "The option was renamed to `services.thelounge.public` to follow upstream changes.") ];

  options.services.thelounge = {
    enable = lib.mkEnableOption "The Lounge web IRC client";

    package = lib.mkPackageOption pkgs "thelounge" { };

    public = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Make your The Lounge instance public.
        Setting this to `false` will require you to configure user
        accounts by using the ({command}`thelounge`) command or by adding
        entries in {file}`${dataDir}/users`. You might need to restart
        The Lounge after making changes to the state directory.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "TCP port to listen on for http connections.";
    };

    extraConfig = lib.mkOption {
      default = { };
      type = lib.types.attrs;
      example = lib.literalExpression ''
        {
          reverseProxy = true;
          defaults = {
            name = "Your Network";
            host = "localhost";
            port = 6697;
          };
        }
      '';
      description = ''
        The Lounge's {file}`config.js` contents as attribute set (will be
        converted to JSON to generate the configuration file).

        The options defined here will be merged to the default configuration file.
        Note: In case of duplicate configuration, options from {option}`extraConfig` have priority.

        Documentation: <https://thelounge.chat/docs/server/configuration>
      '';
    };

    plugins = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.package;
      example = lib.literalExpression "[ pkgs.theLoungePlugins.themes.solarized ]";
      description = ''
        The Lounge plugins to install. Plugins can be found in
        `pkgs.theLoungePlugins.plugins` and `pkgs.theLoungePlugins.themes`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.thelounge = {
      description = "The Lounge service user";
      group = "thelounge";
      isSystemUser = true;
    };

    users.groups.thelounge = { };

    systemd.services.thelounge = {
      description = "The Lounge web IRC client";
      wantedBy = [ "multi-user.target" ];
      preStart = "ln -sf ${pkgs.writeText "config.js" configJsData} ${dataDir}/config.js";
      environment.THELOUNGE_PACKAGES = lib.mkIf (cfg.plugins != [ ]) "${plugins}";
      serviceConfig = {
        User = "thelounge";
        StateDirectory = baseNameOf dataDir;
        ExecStart = "${lib.getExe cfg.package} start";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta = {
    maintainers = with lib.maintainers; [ winter ];
  };
}
