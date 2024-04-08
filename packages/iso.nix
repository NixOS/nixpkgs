{ inputs, ... }@flakeContext:
let
  isoModule = { config, lib, pkgs, ... }: {
    config = {
      boot = {
        loader = {
          timeout = lib.mkForce 1;
          grub = {
            timeoutStyle = "countdown";
          };
        };
      };
      environment = {
        systemPackages = [
          pkgs.nyancat
        ];
      };
      networking = {
        hostName = "xnode";
      };
      users = {
        users = {
          xnode = {
            isNormalUser = true;
            password = "xnode";
          };
        };
      };
    };
  };
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "iso";
  modules = [
    isoModule
  ];
}
