{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.manyfold;
in
{
  meta.teams = with lib.teams; [ ngi ];

  options.services.manyfold = {
    enable = lib.mkEnableOption "Manyfold, an ActivityPub-powered tool for storing and sharing 3D models";
    package = lib.mkPackageOption pkgs "manyfold" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "manyfold";
      description = "The user to run Manyfold under.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "manyfold";
      description = "The group to run Manyfold under.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3214;
      description = "The port where Manyfold is accessible.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = { };
      };
      default = { };
      description = ''
        Configuration for Manyfold, will be passed as environment variables.
        See <https://manyfold.app/sysadmin/configuration.html>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.manyfold = {
      description = "Manyfold";
      after = [ "redis-manyfold.service" ];

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "manyfold";
        WorkingDirectory = "/var/lib/manyfold";
        ExecStart = "${lib.getExe pkgs.goreman} -b ${toString cfg.port} start";
        Restart = "always";
        NoNewPrivileges = true;
      };

      preStart = ''
        ${lib.getExe pkgs.rsync} -a --chmod=u+w --exclude node_modules ${cfg.package}/lib/manyfold/ .
        ln -sf ${cfg.package}/lib/manyfold/node_modules .

        bundle exec rails db:prepare:with_data
        bundle exec rake db:chown
        bundle exec rake tmp:cache:clear
      '';

      path = [
        pkgs.file
        pkgs.f3d
        pkgs.imagemagick
        cfg.package
      ];

      environment = {
        # dynamically loaded by ruby gems
        LD_LIBRARY_PATH = lib.makeLibraryPath [
          pkgs.assimp
          pkgs.libarchive
        ];
        BUNDLE_WITHOUT = "development:test";
        RACK_ENV = "production";
        RAILS_ENV = "production";
        NODE_ENV = "production";
        RAILS_SERVE_STATIC_FILES = "true";
        AWS_RESPONSE_CHECKSUM_VALIDATION = "when_required";
        AWS_REQUEST_CHECKSUM_CALCULATION = "when_required";
        RAILS_LOG_TO_STDOUT = "true";
        RAILS_PORT = toString cfg.port;
        REDIS_URL = lib.mkDefault (
          if config.services.redis.servers.manyfold.port != 0 then
            "redis://127.0.0.1:${toString config.services.redis.servers.manyfold.port}/0"
          else
            "unix://${config.services.redis.servers.manyfold.unixSocket}"
        );
      }
      // cfg.settings;

      wantedBy = [ "multi-user.target" ];
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        inherit (cfg) group;
        isSystemUser = true;
        extraGroups = lib.optional (config.services.redis.servers.manyfold.port == 0) config.services.redis.servers.manyfold.group;
      };
    };

    services.redis.servers.manyfold = {
      enable = true;
      port = lib.mkDefault 6379;
    };
  };
}
