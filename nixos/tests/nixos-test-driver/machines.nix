rec {
  basic = { ... }: {
    imports = [ ../../modules/profiles/minimal.nix ];
  };
  tty = { ... }: {
    services.getty.autologinUser = "root";
  };
  server = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.python3 ];
    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
  client = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.curl ];
  };
  x11 = { pkgs, ... }: {
    imports = [
      ../common/x11.nix
      ../common/user-account.nix
      ../common/auto.nix
    ];
  };
}
