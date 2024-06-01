{ inputs, ... }@flakeContext:
let
  netboot = { config, lib, pkgs, ... }: {
    config = {
      documentation = {
        nixos = {
          enable = false;
        };
        doc = {
          enable = false;
        };
      };
      services = {
        getty = {
          greetingLine = ''<<< Welcome to Openmesh Xnode/OS ${config.system.nixos.label} (\m) - \l >>>'';
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
  customFormats = { "netboot" = import ./image/format/netboot.nix; };
  format = "netboot";
  modules = [
    netboot
  ];
}
