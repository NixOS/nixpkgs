{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mwlib;
  pypkgs = pkgs.python27Packages;

  inherit (pypkgs) python mwlib;

  user = mkOption {
    default = "nobody";
    type = types.str;
    description = "User to run as.";
  };

in
{

  options.services.mwlib = {

    nserve = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable nserve. Nserve is a HTTP
          server.  The Collection extension is talking to
          that program directly.  Nserve uses at least
          one qserve instance in order to distribute
          and manage jobs.
        '';
      }; # nserve.enable

      port = mkOption {
        default = 8899;
        type = types.port;
        description = "Specify port to listen on.";
      }; # nserve.port

      address = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = "Specify network interface to listen on.";
      }; # nserve.address

      qserve = mkOption {
        default = [ "${cfg.qserve.address}:${toString cfg.qserve.port}" ];
        type = types.listOf types.str;
        description = "Register qserve instance.";
      }; # nserve.qserve

      inherit user;
    }; # nserve

    qserve = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          A job queue server used to distribute and manage
          jobs. You should start one qserve instance
          for each machine that is supposed to render pdf
          files. Unless you’re operating the Wikipedia
          installation, one machine should suffice.
        '';
      }; # qserve.enable

      port = mkOption {
        default = 14311;
        type = types.port;
        description = "Specify port to listen on.";
      }; # qserve.port

      address = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = "Specify network interface to listen on.";
      }; # qserve.address

      datadir = mkOption {
        default = "/var/lib/mwlib-qserve";
        type = types.path;
        description = "qserve data directory (FIXME: unused?)";
      }; # qserve.datadir

      allow = mkOption {
        default = [ "127.0.0.1" ];
        type = types.listOf types.str;
        description = "List of allowed client IPs. Empty means any.";
      }; # qserve.allow

      inherit user;
    }; # qserve

    nslave = {
      enable = mkOption {
        default = cfg.qserve.enable;
        type = types.bool;
        description = ''
          Pulls new jobs from exactly one qserve instance
          and calls the zip and render programs
          in order to download article collections and
          convert them to different output formats. Nslave
          uses a cache directory to store the generated
          documents. Nslave also starts an internal http
          server serving the content of the cache directory.
        '';
      }; # nslave.enable

      cachedir = mkOption {
        default = "/var/cache/mwlib-nslave";
        type = types.path;
        description = "Directory to store generated documents.";
      }; # nslave.cachedir

      numprocs = mkOption {
        default = 10;
        type = types.int;
        description = "Number of parallel jobs to be executed.";
      }; # nslave.numprocs

      http = mkOption {
        default = {};
        description = ''
          Internal http server serving the content of the cache directory.
          You have to enable it, or use your own way for serving files
          and set the http.url option accordingly.
          '';
        type = types.submodule ({
          options = {
            enable = mkOption {
              default = true;
              type = types.bool;
              description = "Enable internal http server.";
            }; # nslave.http.enable

            port = mkOption {
              default = 8898;
              type = types.port;
              description = "Port to listen to when serving files from cache.";
            }; # nslave.http.port

            address = mkOption {
              default = "127.0.0.1";
              type = types.str;
              description = "Specify network interface to listen on.";
            }; # nslave.http.address

            url = mkOption {
              default = "http://localhost:${toString cfg.nslave.http.port}/cache";
              type = types.str;
              description = ''
                Specify URL for accessing generated files from cache.
                The Collection extension of Mediawiki won't be able to
                download files without it.
                '';
            }; # nslave.http.url
          };
        }); # types.submodule
      }; # nslave.http

      inherit user;
    }; # nslave

  }; # options.services

  config = {

    systemd.services.mwlib-nserve = mkIf cfg.nserve.enable
    {
      description = "mwlib network interface";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "mwlib-qserve.service" ];

      serviceConfig = {
        ExecStart = concatStringsSep " " (
          [
            "${mwlib}/bin/nserve"
            "--port ${toString cfg.nserve.port}"
            "--interface ${cfg.nserve.address}"
          ] ++ cfg.nserve.qserve
        );
        User = cfg.nserve.user;
      };
    }; # systemd.services.mwlib-nserve

    systemd.services.mwlib-qserve = mkIf cfg.qserve.enable
    {
      description = "mwlib job queue server";

      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -pv '${cfg.qserve.datadir}'
        chown -Rc ${cfg.qserve.user}:`id -ng ${cfg.qserve.user}` '${cfg.qserve.datadir}'
        chmod -Rc u=rwX,go= '${cfg.qserve.datadir}'
      '';

      serviceConfig = {
        ExecStart = concatStringsSep " " (
          [
            "${mwlib}/bin/mw-qserve"
            "-p ${toString cfg.qserve.port}"
            "-i ${cfg.qserve.address}"
            "-d ${cfg.qserve.datadir}"
          ] ++ map (a: "-a ${a}") cfg.qserve.allow
        );
        User = cfg.qserve.user;
        PermissionsStartOnly = true;
      };
    }; # systemd.services.mwlib-qserve

    systemd.services.mwlib-nslave = mkIf cfg.nslave.enable
    {
      description = "mwlib worker";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -pv '${cfg.nslave.cachedir}'
        chown -Rc ${cfg.nslave.user}:`id -ng ${cfg.nslave.user}` '${cfg.nslave.cachedir}'
        chmod -Rc u=rwX,go= '${cfg.nslave.cachedir}'
      '';

      path = with pkgs; [ imagemagick pdftk ];
      environment = {
        PYTHONPATH = concatMapStringsSep ":"
          (m: "${pypkgs.${m}}/lib/${python.libPrefix}/site-packages")
          [ "mwlib-rl" "mwlib-ext" "pygments" "pyfribidi" ];
      };

      serviceConfig = {
        ExecStart = concatStringsSep " " (
          [
            "${mwlib}/bin/nslave"
            "--cachedir ${cfg.nslave.cachedir}"
            "--numprocs ${toString cfg.nslave.numprocs}"
            "--url ${cfg.nslave.http.url}"
          ] ++ (
            if cfg.nslave.http.enable then
            [
              "--serve-files-port ${toString cfg.nslave.http.port}"
              "--serve-files-address ${cfg.nslave.http.address}"
            ] else
            [
              "--no-serve-files"
            ]
          ));
        User = cfg.nslave.user;
        PermissionsStartOnly = true;
      };
    }; # systemd.services.mwlib-nslave

  }; # config
}
