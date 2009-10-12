{ config, pkgs, ... }:

with pkgs.lib;

let

  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";
  
  cfg = config.services.bind;

  confFile = pkgs.writeText "named.conf"
    ''
      acl cachenetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on {any;};
        listen-on-v6 {any;};
        allow-query { cachenetworks; };
        blackhole { badnetworks; };
        forward first;
        forwarders { ${concatMapStrings (entry: " ${entry}; ") config.networking.nameservers} };
        directory "/var/run/named";
        pid-file "/var/run/named/named.pid";
      };

      ${ concatMapStrings
          ({ name, file, master ? true, slaves ? [], masters ? [] }:
            ''           
              zone "${name}" {
                type ${if master then "master" else "slave"};
                file "${file}";
                ${ if master then
                   ''
                     allow-transfer {
                       ${concatMapStrings (ip: "${ip};\n") slaves}
                     };
                   ''
                   else
                   ''
                     masters {
                       ${concatMapStrings (ip: "${ip};\n") masters}
                     };
                   ''
                }
                allow-query { any; };
              };
            '')
          cfg.zones }
    '';

in

{

  ###### interface

  options = {
  
    services.bind = {
    
      enable = mkOption {
        default = false;
        description = "
          Whether to enable BIND domain name server.
        ";
      };
      
      cacheNetworks = mkOption {
        default = ["127.0.0.0/24"];
        description = "
          What networks are allowed to use us as a resolver.
        ";
      };
      
      blockedNetworks = mkOption {
        default = [];
        description = "
          What networks are just blocked.
        ";
      };
      
      zones = mkOption {
        default = [];
        description = "
          List of zones we claim authority over.
            master=false means slave server; slaves means addresses 
           who may request zone transfer.
        ";
        example = [{
          name = "example.com";
          master = false;
          file = "/var/dns/example.com";
          masters = ["192.168.0.1"];
          slaves = [];
        }];
      };
      
    };

  };
  

  ###### implementation

  config = mkIf config.services.bind.enable {

    jobAttrs.bind =
      { description = "BIND name server job";

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -p /var/run/named
          '';

        exec = "${pkgs.bind}/sbin/named -c ${confFile} -f";
      };

  };
  
}
