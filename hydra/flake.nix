{
  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            boot.isNspawnContainer = true;

            services.hydra = {
              enable = true;
              hydraURL = "http://localhost:3000";
              notificationSender = "hydra@localhost";
              useSubstitutes = true;
            };

            networking.firewall.allowedTCPPorts = [ 3000 ];
            networking.useHostResolvConf = nixpkgs.lib.mkForce false;
            networking.nameservers = [ "8.8.8.8" ];

            programs.ssh.extraConfig = nixpkgs.lib.mkAfter ''
              Host cygwin-vm
                User Quickemu
                HostName 10.233.1.1
                Port = 22220
            '';

            services.openssh = {
              knownHosts = {
                cygwin-vm = {
                  hostNames = [ "[10.233.1.1]:22220" ];
                  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJGc5UkkNeYGjBLpgvdZZ8GeW8QtZsvC9IuTMNzLJ/N";
                };
              };
            };

            nix.distributedBuilds = true;
            nix.buildMachines = [
              {
                hostName = "cygwin-vm";
                system = "x86_64-cygwin";
              }
            ];
          }
        ];
      };
    };
}
