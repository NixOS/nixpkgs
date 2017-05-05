{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface
  options = {
    programs.browserpass = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install the NativeMessaging configuration for installed browsers.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.programs.browserpass.enable {
    environment.systemPackages = [ pkgs.browserpass ];
    environment.etc."chromium/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-host.json";
    environment.etc."opt/chrome/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-host.json";
  };
}
