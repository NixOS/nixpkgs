{ config, pkgs, lib, ... }:

{
  options.services.parsec-host = {
    enable = lib.mkEnableOption "Parsec Host compatibility layer (via Sunshine)";

    backend = lib.mkOption {
      type = lib.types.enum [ "sunshine" "none" ];
      default = "sunshine";
      description = "Backend used to provide hosting capabilities for Parsec on Linux.";
    };
  };

  config = lib.mkIf config.services.parsec-host.enable {
    environment.systemPackages = with pkgs; [
      parsec
      (if config.services.parsec-host.backend == "sunshine" then sunshine else null)
    ];

    services.udev.extraRules = [
      "KERNEL==\"uinput\", MODE=\"0660\", GROUP=\"input\""
    ];

    users.users.parsec-host = {
      isNormalUser = true;
      extraGroups = [ "input" "video" "audio" ];
    };

    networking.firewall.allowedTCPPorts = [ 47984 47989 ];
    networking.firewall.allowedUDPPorts = [ 47998 47999 48000 ];

    systemd.services.parsec-host-sunshine = lib.mkIf (config.services.parsec-host.backend == "sunshine") {
      description = "Parsec Host Compatibility Service (Sunshine)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.sunshine}/bin/sunshine";
        Restart = "on-failure";
        User = "parsec-host";
        Group = "parsec-host";
        Environment = "DISPLAY=:0";
      };
    };
  };
}
