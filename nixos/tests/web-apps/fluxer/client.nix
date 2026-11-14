{ cert }:
{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.curl
    pkgs.jq
  ];
  networking = {
    interfaces.eth1 = {
      ipv4.addresses = [
        {
          address = "192.168.2.102";
          prefixLength = 24;
        }
      ];
    };
    extraHosts = ''
      192.168.2.101 fluxer.local
    '';
  };

  security = {
    pki.certificateFiles = [ "${cert}/cert.pem" ];
  };
}
