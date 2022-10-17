{ pkgs, ... }:
let
  inherit (import ./../ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;
in {
  networking.firewall.allowedTCPPorts = [ 80 ];

  systemd.services.mock-google-metadata = {
    description = "Mock Google metadata service";
    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${pkgs.python3}/bin/python ${./server.py}";
    environment = {
      SNAKEOIL_PUBLIC_KEY = snakeOilPublicKey;
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  services.openssh.enable = true;
  services.openssh.kbdInteractiveAuthentication = false;
  services.openssh.passwordAuthentication = false;

  security.googleOsLogin.enable = true;

  # Mock google service
  networking.interfaces.lo.ipv4.addresses = [ { address = "169.254.169.254"; prefixLength = 32; } ];
}
