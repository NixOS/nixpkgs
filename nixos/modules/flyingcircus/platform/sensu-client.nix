{ config, pkgs, lib, ... }:

with lib;

let

  sensu_server = lib.findFirst
    (s: s.service == "sensuserver-server")
    null
    config.flyingcircus.enc_services;

in

{

   config = mkIf (sensu_server != null) {
     flyingcircus.services.sensu-client = {
       enable = true;
       server = sensu_server.address;
       password = sensu_server.password;
     };
   };

}
