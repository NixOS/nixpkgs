{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.calibre-server;

  documentationLink = "https://manual.calibre-ebook.com";
  generatedDocumentationLink = documentationLink + "/generated/en/calibre-server.html";

  execFlags = (concatStringsSep " "
    (mapAttrsToList (k: v: "${k} ${toString v}") (filterAttrs (name: value: value != null) {
      "--listen-on" = cfg.host;
      "--port" = cfg.port;
      "--auth-mode" = cfg.auth.mode;
      "--userdb" = cfg.auth.userDb;
    }) ++ [(optionalString (cfg.auth.enable == true) "--enable-auth")])
  );
in

{
  imports = [
    (mkChangedOptionModule [ "services" "calibre-server" "libraryDir" ] [ "services" "calibre-server" "libraries" ]
      (config:
        let libraryDir = getAttrFromPath [ "services" "calibre-server" "libraryDir" ] config;
        in [ libraryDir ]
      )
    )
  ];

  options = {
    services.calibre-server = {

      enable = mkEnableOption "calibre-server (e-book software)";
      package = lib.mkPackageOption pkgs "calibre" { };

      libraries = mkOption {
        type = types.listOf types.path;
        default = [ "/var/lib/calibre-server" ];
        description = ''
          Make sure each library path is initialized before service startup.
          The directories of the libraries to serve. They must be readable for the user under which the server runs.
          See the [calibredb documentation](${documentationLink}/generated/en/calibredb.html#add) for details.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "calibre-server";
        description = "The user under which calibre-server runs.";
      };

      group = mkOption {
        type = types.str;
        default = "calibre-server";
        description = "The group under which calibre-server runs.";
      };

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "::1";
        description = ''
          The interface on which to listen for connections.
          See the [calibre-server documentation](${generatedDocumentationLink}#cmdoption-calibre-server-listen-on) for details.
        '';
      };

      port = mkOption {
        default = 8080;
        type = types.port;
        description = ''
          The port on which to listen for connections.
          See the [calibre-server documentation](${generatedDocumentationLink}#cmdoption-calibre-server-port) for details.
        '';
      };

      auth = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Password based authentication to access the server.
            See the [calibre-server documentation](${generatedDocumentationLink}#cmdoption-calibre-server-enable-auth) for details.
          '';
        };

        mode = mkOption {
          type = types.enum [ "auto" "basic" "digest" ];
          default = "auto";
          description = ''
            Choose the type of authentication used.
            Set the HTTP authentication mode used by the server.
            See the [calibre-server documentation](${generatedDocumentationLink}#cmdoption-calibre-server-auth-mode) for details.
          '';
        };

        userDb = mkOption {
          default = null;
          type = types.nullOr types.path;
          description = ''
            Choose users database file to use for authentication.
            Make sure users database file is initialized before service startup.
            See the [calibre-server documentation](${documentationLink}/server.html#managing-user-accounts-from-the-command-line-only) for details.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.calibre-server = {
      description = "Calibre Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Restart = "always";
        ExecStart = "${cfg.package}/bin/calibre-server ${lib.concatStringsSep " " cfg.libraries} ${execFlags}";
      };

    };

    environment.systemPackages = [ pkgs.calibre ];

    users.users = optionalAttrs (cfg.user == "calibre-server") {
      calibre-server = {
        home = "/var/lib/calibre-server";
        createHome = true;
        uid = config.ids.uids.calibre-server;
        group = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "calibre-server") {
      calibre-server = {
        gid = config.ids.gids.calibre-server;
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ gaelreyrol ];
}
