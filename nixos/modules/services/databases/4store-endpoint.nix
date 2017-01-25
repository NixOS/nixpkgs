{ config, lib, pkgs, ... }:
let
  cfg = config.services.fourStoreEndpoint;
  endpointUser = "fourstorehttp";
  run = "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${endpointUser} -c";
in
with lib;
{

  ###### interface

  options = {

    services.fourStoreEndpoint = {

      enable = mkOption {
        default = false;
        description = "Whether to enable 4Store SPARQL endpoint.";
      };

      database = mkOption {
        default = config.services.fourStore.database;
        description = "RDF database name to expose via the endpoint. Defaults to local 4Store database name.";
      };

      listenAddress = mkOption {
        default = null;
        description = "IP address to listen on.";
      };

      port = mkOption {
        default = 8080;
        description = "port to listen on.";
      };

      options = mkOption {
        default = "";
        description = "Extra CLI options to pass to 4Store's 4s-httpd process.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = singleton
      { assertion = cfg.enable -> cfg.database != "";
        message = "Must specify 4Store database name";
      };

    users.extraUsers = singleton
      { name = endpointUser;
        uid = config.ids.uids.fourstorehttp;
        description = "4Store SPARQL endpoint user";
      };

    services.avahi.enable = true;

    systemd.services."4store-endpoint" = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        ${run} '${pkgs.rdf4store}/bin/4s-httpd -D ${cfg.options} ${if cfg.listenAddress!=null then "-H ${cfg.listenAddress}" else "" } -p ${toString cfg.port} ${cfg.database}'
      '';
    };

  };

}
