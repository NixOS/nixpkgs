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
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.passwordAuthentication = false;

  security.googleOsLogin.enable = true;

  # Mock google service
  networking.extraHosts = ''
    127.0.0.1 metadata.google.internal
  '';
}
