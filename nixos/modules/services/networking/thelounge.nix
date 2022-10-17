{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.thelounge;
  dataDir = "/var/lib/thelounge";
  configJsData = "module.exports = " + builtins.toJSON (
    { inherit (cfg) public port; } // cfg.extraConfig
  );
  pluginManifest = {
    dependencies = builtins.listToAttrs (builtins.map (pkg: { name = getName pkg; value = getVersion pkg; }) cfg.plugins);
  };
  plugins = pkgs.runCommandLocal "thelounge-plugins" { } ''
    mkdir -p $out/node_modules
    echo ${escapeShellArg (builtins.toJSON pluginManifest)} >> $out/package.json
    ${concatMapStringsSep "\n" (pkg: ''
    ln -s ${pkg}/lib/node_modules/${getName pkg} $out/node_modules/${getName pkg}
    '') cfg.plugins}
  '';
in
{
  imports = [ (mkRemovedOptionModule [ "services" "thelounge" "private" ] "The option was renamed to `services.thelounge.public` to follow upstream changes.") ];

  options.services.thelounge = {
    enable = mkEnableOption (lib.mdDoc "The Lounge web IRC client");

    public = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Make your The Lounge instance public.
        Setting this to `false` will require you to configure user
        accounts by using the ({command}`thelounge`) command or by adding
        entries in {file}`${dataDir}/users`. You might need to restart
        The Lounge after making changes to the state directory.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 9000;
      description = lib.mdDoc "TCP port to listen on for http connections.";
    };

    extraConfig = mkOption {
      default = { };
      type = types.attrs;
      example = literalExpression ''{
        reverseProxy = true;
        defaults = {
          name = "Your Network";
          host = "localhost";
          port = 6697;
        };
      }'';
      description = lib.mdDoc ''
        The Lounge's {file}`config.js` contents as attribute set (will be
        converted to JSON to generate the configuration file).

        The options defined here will be merged to the default configuration file.
        Note: In case of duplicate configuration, options from {option}`extraConfig` have priority.

        Documentation: <https://thelounge.chat/docs/server/configuration>
      '';
    };

    plugins = mkOption {
      default = [ ];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.theLoungePlugins.themes.solarized ]";
      description = lib.mdDoc ''
        The Lounge plugins to install. Plugins can be found in
        `pkgs.theLoungePlugins.plugins` and `pkgs.theLoungePlugins.themes`.
      '';
    };
  };

  config = mkIf cfg.enable {
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
      environment.THELOUNGE_PACKAGES = mkIf (cfg.plugins != [ ]) "${plugins}";
      serviceConfig = {
        User = "thelounge";
        StateDirectory = baseNameOf dataDir;
        ExecStart = "${pkgs.thelounge}/bin/thelounge start";
      };
    };

    environment.systemPackages = [ pkgs.thelounge ];
  };

  meta = {
    maintainers = with lib.maintainers; [ winter ];
  };
}
