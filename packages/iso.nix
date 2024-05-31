{ inputs, sshPubKey ? "", ... }@flakeContext:
let
  isoModule = { config, lib, pkgs, ... }: {
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
        openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
        };
      };
      boot = {
        loader = {
          timeout = lib.mkForce 1;
          grub = {
            timeoutStyle = lib.mkForce "countdown";
          };
        };
      };
      isoImage = {
        forceTextMode = true;
        makeBiosBootable = true;
        makeEfiBootable = true;
        makeUsbBootable = true;
      };
      environment = {
        systemPackages = [
          pkgs.prometheus pkgs.grafana pkgs.kubo #pkgs.openmesh-core
        ];
      };
      networking = {
        hostName = "xnode";
      };
      users = {
        users = {
          "xnode" = {
            isNormalUser = true;
            password = "xnode";
            openssh.authorizedKeys.keys = [ sshPubKey ]; # Inject a key from environment or through --args
            extraGroups = [ "wheel" ];
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
  