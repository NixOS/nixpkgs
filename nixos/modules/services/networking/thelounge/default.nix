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
    echo ${escapeShellArg (builtins.toJSON pluginManifest)} > $out/package.json
    ${concatMapStringsSep "\n" (pkg: ''
      ln -s ${pkg}/lib/node_modules/${getName pkg} $out/node_modules/${getName pkg}
    '') cfg.plugins}
  '';
  userOptions = {
    options =
      let
        passwordDesc = ''
          This can be generated with <literal>mkpasswd -m bcrypt -R 11</literal>.
        '';
      in
      {
        hashedPassword = mkOption {
          type = types.nullOr types.nonEmptyStr;
          default = null;
          description = ''
            The hashed password for this user. ${passwordDesc}
          '';
        };

        hashedPasswordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The path to a file containing the hashed password for this user. ${passwordDesc}
          '';
        };

        enableLogging = (mkEnableOption "message logging for this user") // { default = true; };
      };
  };
in
{
  imports = [ (mkRemovedOptionModule [ "services" "thelounge" "private" ] "The option was renamed to `services.thelounge.public` to follow upstream changes.") ];

  options.services.thelounge = {
    enable = mkEnableOption "The Lounge web IRC client";

    public = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make your The Lounge instance public.
        Setting this to <literal>false</literal> will require you to configure user
        accounts by using the (<command>thelounge</command>) command or by adding
        entries in <filename>${dataDir}/users</filename>. You might need to restart
        The Lounge after making changes to the state directory.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 9000;
      description = "TCP port to listen on for http connections.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = { };
      example = literalExpression ''
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
        The Lounge's <filename>config.js</filename> contents as attribute set (will be
        converted to JSON to generate the configuration file).

        The options defined here will be merged to the default configuration file.
        Note: In case of duplicate configuration, options from <option>extraConfig</option> have priority.

        Documentation: <link xlink:href="https://thelounge.chat/docs/server/configuration" />
      '';
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.theLoungePlugins.themes.solarized ]";
      description = ''
        The Lounge plugins to install. Plugins can be found in
        <literal>pkgs.theLoungePlugins.plugins</literal> and <literal>pkgs.theLoungePlugins.themes</literal>.
      '';
    };

    users = mkOption {
      type = types.attrsOf (types.submodule userOptions);
      default = { };
      example = literalExpression ''
        john = {
          hashedPassword = "$2b$05$fK.qf8vOxvOeSA4D3W0znOhkASuXTceypm6uwqPkrAHh7bWaji7U2";
        };
      '';
      description = ''
        A list of The Lounge users.
      '';
    };

    mutableUsers = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If set to <literal>true</literal>, you are free to add new users to The Lounge
        with the ordinary <literal>thelounge add</literal> command.
        On system activation, the existing list of users will be merged with the
        list generated from the <literal>services.thelounge.users</literal> option.
        The initial password for a user will be set
        according to <literal>services.thelounge.users</literal>, but existing passwords
        will not be changed.
        <warning><para>
        If set to <literal>false</literal>, the users list will simply
        be replaced on system activation. This also
        holds for the user passwords; all changed
        passwords will be reset according to the
        <literal>services.thelounge.users</literal> configuration on activation.
        </para></warning>
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (builtins.length (builtins.attrNames cfg.users)) == 0 || !cfg.public;
        message = "services.thelounge.users cannot be set if services.thelounge.public is true. (${toString (builtins.length (builtins.attrNames cfg.users))})";
      }
    ]
    ++ mapAttrsToList
      (name: user:
        {
          assertion = (user.hashedPassword != null && user.hashedPasswordFile == null) || (user.hashedPasswordFile != null && user.hashedPassword == null);
          message = "Exactly one of services.thelounge.users.${name}.hashedPassword or services.thelounge.users.${name}.hashedPasswordFile must be set.";
        }
      )
      cfg.users;

    users.users.thelounge = {
      description = "The Lounge service user";
      group = "thelounge";
      isSystemUser = true;
    };

    users.groups.thelounge = { };

    systemd.services.thelounge = {
      description = "The Lounge web IRC client";
      wantedBy = [ "multi-user.target" ];
      preStart =
        let
          script = pkgs.writers.writePython3 "thelounge-pre-start" { flakeIgnore = [ "E501" ]; } (builtins.readFile ./update-users.py);
        in
        ''
          ${script} ${dataDir} \
            ${pkgs.writeText "thelounge-config" configJsData} \
            ${boolToString cfg.mutableUsers} \
            ${escapeShellArg (builtins.toJSON cfg.users)}
        '';
      environment.THELOUNGE_PACKAGES = mkIf (cfg.plugins != [ ]) "${plugins}";
      serviceConfig = {
        User = "thelounge";
        Group = "thelounge";
        StateDirectory = builtins.baseNameOf dataDir;
        ExecStart = "${pkgs.thelounge}/bin/thelounge start";
      };
    };

    environment.systemPackages =
      let
        thelounge =
          if cfg.plugins != [ ] then
            pkgs.runCommand "thelounge-wrapper"
              {
                buildInputs = [ pkgs.makeWrapper ];
              }
              "makeWrapper ${pkgs.thelounge}/bin/thelounge $out/bin/thelounge --prefix THELOUNGE_PACKAGES : ${plugins}"
          else pkgs.thelounge;
      in
      [ thelounge ];
  };

  meta = {
    maintainers = with lib.maintainers; [ winter ];
  };
}

