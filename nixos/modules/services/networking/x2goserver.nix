{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.x2goserver;

  defaults = {
    superenicer = { enable = cfg.superenicer.enable; };
  };
  confText = generators.toINI {} (recursiveUpdate defaults cfg.settings);
  x2goServerConf = pkgs.writeText "x2goserver.conf" confText;

  x2goAgentOptions = pkgs.writeText "x2goagent.options" ''
    X2GO_NXOPTIONS=""
    X2GO_NXAGENT_DEFAULT_OPTIONS="${concatStringsSep " " cfg.nxagentDefaultOptions}"
  '';

in {
  imports = [
    (mkRenamedOptionModule [ "programs" "x2goserver" ] [ "services" "x2goserver" ])
  ];

  options.services.x2goserver = {
    enable = mkEnableOption "x2goserver" // {
      description = ''
        Enables the x2goserver module.
        NOTE: This will create a good amount of symlinks in `/usr/local/bin`
      '';
    };

    superenicer = {
      enable = mkEnableOption "superenicer" // {
        description = ''
          Enables the SupeReNicer code in x2gocleansessions, this will renice
          suspended sessions to nice level 19 and renice them to level 0 if the
          session becomes marked as running again
        '';
      };
    };

    nxagentDefaultOptions = mkOption {
      type = types.listOf types.str;
      default = [ "-extension GLX" "-nolisten tcp" ];
      description = ''
        List of default nx agent options.
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      description = ''
        x2goserver.conf ini configuration as nix attributes. See
        `x2goserver.conf(5)` for details
      '';
      example = literalExpression ''
        {
          superenicer = {
            "enable" = "yes";
            "idle-nice-level" = 19;
          };
          telekinesis = { "enable" = "no"; };
        }
      '';
    };
  };

  config = mkIf cfg.enable {

    # x2goserver can run X11 program even if "services.xserver.enable = false"
    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };

    environment.systemPackages = [ pkgs.x2goserver ];

    users.groups.x2go = {};
    users.users.x2go = {
      home = "/var/lib/x2go/db";
      group = "x2go";
      isSystemUser = true;
    };

    security.wrappers.x2gosqliteWrapper = {
      source = "${pkgs.x2goserver}/lib/x2go/libx2go-server-db-sqlite3-wrapper.pl";
      owner = "x2go";
      group = "x2go";
      setuid = false;
      setgid = true;
    };
    security.wrappers.x2goprintWrapper = {
      source = "${pkgs.x2goserver}/bin/x2goprint";
      owner = "x2go";
      group = "x2go";
      setuid = false;
      setgid = true;
    };

    systemd.tmpfiles.rules = with pkgs; [
      "d /var/lib/x2go/ - x2go x2go - -"
      "d /var/lib/x2go/db - x2go x2go - -"
      "d /var/lib/x2go/conf - x2go x2go - -"
      "d /run/x2go 0755 x2go x2go - -"
    ] ++
    # x2goclient sends SSH commands with preset PATH set to
    # "/usr/local/bin;/usr/bin;/bin". Since we cannot filter arbitrary ssh
    # commands, we have to make the following executables available.
    map (f: "L+ /usr/local/bin/${f} - - - - ${x2goserver}/bin/${f}") [
      "x2goagent" "x2gobasepath" "x2gocleansessions" "x2gocmdexitmessage"
      "x2godbadmin" "x2gofeature" "x2gofeaturelist" "x2gofm" "x2gogetapps"
      "x2gogetservers" "x2golistdesktops" "x2golistmounts" "x2golistsessions"
      "x2golistsessions_root" "x2golistshadowsessions" "x2gomountdirs"
      "x2gopath" "x2goprint" "x2goresume-desktopsharing" "x2goresume-session"
      "x2goruncommand" "x2goserver-run-extensions" "x2gosessionlimit"
      "x2gosetkeyboard" "x2goshowblocks" "x2gostartagent"
      "x2gosuspend-desktopsharing" "x2gosuspend-session"
      "x2goterminate-desktopsharing" "x2goterminate-session"
      "x2goumount-session" "x2goversion"
    ] ++ [
      "L+ /usr/local/bin/awk - - - - ${gawk}/bin/awk"
      "L+ /usr/local/bin/chmod - - - - ${coreutils}/bin/chmod"
      "L+ /usr/local/bin/cp - - - - ${coreutils}/bin/cp"
      "L+ /usr/local/bin/sed - - - - ${gnused}/bin/sed"
      "L+ /usr/local/bin/setsid - - - - ${util-linux}/bin/setsid"
      "L+ /usr/local/bin/xrandr - - - - ${xorg.xrandr}/bin/xrandr"
      "L+ /usr/local/bin/xmodmap - - - - ${xorg.xmodmap}/bin/xmodmap"
    ];

    systemd.services.x2goserver = {
      description = "X2Go Server Daemon";
      wantedBy = [ "multi-user.target" ];
      unitConfig.Documentation = "man:x2goserver.conf(5)";
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.x2goserver}/bin/x2gocleansessions";
        PIDFile = "/run/x2go/x2goserver.pid";
        User = "x2go";
        Group = "x2go";
        RuntimeDirectory = "x2go";
        StateDirectory = "x2go";
      };
      preStart = ''
        if [ ! -e /var/lib/x2go/setup_ran ]
        then
          mkdir -p /var/lib/x2go/conf
          cp -r ${pkgs.x2goserver}/etc/x2go/* /var/lib/x2go/conf/
          ln -sf ${x2goServerConf} /var/lib/x2go/conf/x2goserver.conf
          ln -sf ${x2goAgentOptions} /var/lib/x2go/conf/x2goagent.options
          ${pkgs.x2goserver}/bin/x2godbadmin --createdb
          touch /var/lib/x2go/setup_ran
        fi
      '';
    };

    # https://bugs.x2go.org/cgi-bin/bugreport.cgi?bug=276
    security.sudo.extraConfig = ''
      Defaults  env_keep+=QT_GRAPHICSSYSTEM
    '';
    security.sudo-rs.extraConfig = ''
      Defaults  env_keep+=QT_GRAPHICSSYSTEM
    '';
  };
}
