{ cert }:
{ pkgs, ... }:
{
  networking = {
    interfaces.eth1 = {
      ipv4.addresses = [
        {
          address = "192.168.2.101";
          prefixLength = 24;
        }
      ];
    };
    extraHosts = ''
      192.168.2.101 fluxer.local
    '';
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  security = {
    pki.certificateFiles = [ "${cert}/cert.pem" ];
  };

  services.fluxer = {
    enable = true;
    settings = {
      domain = "fluxer.local";
      vapid.email = "admin@fluxer.local";
      nats = {
        auth_token.file = pkgs.writeText "nats-token" "qn-QniCiH&K95fXhp@9U7O";
        auth_token_bcrypt = "$2a$11$bYlXslI5BORV8gDApIWx3.jf7uASWwVjfDsg2WCDVikdAvVkQSBOK";
      };
    };
    aux = {
      nats.enable = true;
      pgsql.enable = true;
      pgsql.recommendedTuningOptions = true;
      valkey.enable = true;
      meilisearch.enable = true;
      seaweedfs.enable = true;
      livekit.enable = false;
    };
  };
}
