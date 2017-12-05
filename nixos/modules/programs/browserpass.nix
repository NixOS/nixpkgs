{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface
  options = {
    programs.browserpass.enable = mkEnableOption "the NativeMessaging configuration for Chromium, Chrome, and Vivaldi.";
  };

  ###### implementation
  config = mkIf config.programs.browserpass.enable {
    environment.systemPackages = [ pkgs.browserpass ];
    environment.etc = {
      "chromium/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-host.json";
      "chromium/policies/managed/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-policy.json";
      "opt/chrome/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-host.json";
      "opt/chrome/policies/managed/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-policy.json";
    };
  };
}
