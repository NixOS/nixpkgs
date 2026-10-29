{ flakePath, sshPublicKey, port ? 22429, memorySize ? 6144, cores ? 4 }:
let
  flake = builtins.getFlake ("path:" + flakePath);
  nixpkgs = flake.inputs.nixpkgs;
  system = "x86_64-linux";
  vm = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      (nixpkgs.outPath + "/nixos/modules/virtualisation/qemu-vm.nix")
      ({ pkgs, lib, ... }: {
        networking.hostName = "arkhe-repro-vm";
        system.stateVersion = "26.05";
        services.openssh.enable = true;
        services.openssh.settings = { PermitRootLogin = "prohibit-password"; PasswordAuthentication = false; };
        users.users.root.openssh.authorizedKeys.keys = [ sshPublicKey ];
        nix.settings.experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
        nix.settings.sandbox = true;
        nix.settings.max-jobs = 1;
        nix.settings.cores = 3;
        environment.systemPackages = [ pkgs.git pkgs.jq pkgs.python3 ];
        virtualisation = {
          inherit memorySize cores;
          diskSize = 65536;
          graphics = false;
          useNixStoreImage = true;
          mountHostNixStore = false;
          writableStore = true;
          writableStoreUseTmpfs = false;
          sharedDirectories = lib.mkForce { };
          forwardPorts = [ { from = "host"; host.address = "127.0.0.1"; host.port = port; guest.port = 22; } ];
        };
      })
    ];
  };
in vm.config.system.build.vm