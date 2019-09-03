{ pkgs, ... }:
{ nixpkgs.config.packageOverrides = pkgs': {
    hello-world-container = pkgs'.callPackage ./hello-world-container.nix { };
  };

  virtualisation.docker = {
    enable  = true;
    package = pkgs.docker;
  };

  systemd.services.docker-load-fetchdocker-image = {
    description = "Docker load hello-world-container";
    wantedBy    = [ "multi-user.target" ];
    wants       = [ "docker.service" ];
    after       = [ "docker.service" ];

    script = ''
      ${pkgs.hello-world-container}/compositeImage.sh | ${pkgs.docker}/bin/docker load
    '';

    serviceConfig = {
      Type = "oneshot";
    };
  };
}

